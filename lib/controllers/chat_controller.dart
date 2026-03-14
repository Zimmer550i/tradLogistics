import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:template/config/environment.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/models/conversation_model.dart';
import 'package:template/models/message_model.dart';
import 'package:template/network/base_api_service.dart';
import 'package:template/storage/storage_service.dart';
import 'package:template/utils/logger.dart';

class ChatController extends BaseController {
  final _api = BaseApiService();
  final _storage = StorageService();

  final RxnString roomId = RxnString();
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxList<Map<String, dynamic>> participants =
      <Map<String, dynamic>>[].obs;

  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;

  final RxBool isSocketConnected = false.obs;
  final RxBool hasNext = false.obs;
  final RxInt currentPage = 1.obs;

  final Map<int, int> _messageIndexById = <int, int>{};
  final Map<int, String> _roleByUserId = <int, String>{};

  WebSocket? _socket;
  StreamSubscription? _socketSub;
  bool _prependNext = false;

  static const String _conversationsEndpoint = '/chat/conversations/';

  UserProfileController? get _profileController {
    try {
      return Get.find<UserProfileController>();
    } catch (_) {
      return null;
    }
  }

  int? get _currentUserId => _profileController?.userProfile.value?.userId;
  String? get _currentUserRole =>
      _profileController?.userProfile.value?.role ?? _storage.getRole();

  Future<void> connectSocket() async {
    if (roomId.value == null) return;
    final token = _storage.getToken();
    if (token == null || token.isEmpty) return;

    if (_socket != null) {
      await disconnectSocket();
    }

    final url = _buildWsUrl(roomId.value?? "", token);
    try {
      _socket = await WebSocket.connect(url);
      isSocketConnected.value = true;
      _socketSub = _socket!.listen(
        _onSocketData,
        onError: _onSocketError,
        onDone: _onSocketDone,
        cancelOnError: true,
      );
    } catch (e, st) {
      AppLogger.error('Socket connect failed', error: e, stackTrace: st);
      isSocketConnected.value = false;
      _socket = null;
    }
  }

  Future<void> disconnectSocket() async {
    await _socketSub?.cancel();
    _socketSub = null;
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
    isSocketConnected.value = false;
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final socket = _socket;
    if (socket == null) return;

    final payload = <String, dynamic>{'type': 'message', 'text': text};
    socket.add(jsonEncode(payload));
  }

  Future<String?> createConversation({
    required int userId,
    required int deliveryId,
  }) async {
    return apiCall<String?>(() async {
      final data = await _api.post(
        _conversationsEndpoint,
        body: {'user_id': userId, 'delivery_id': deliveryId},
      );
      final payload = data is Map<String, dynamic> ? data['data'] : null;
      if (payload is Map<String, dynamic>) {
        return payload['public_id']?.toString();
      }
      return null;
    }, showOverlay: true);
  }

  Future<void> fetchConversations() async {
    await apiCall(() async {
      final data = await _api.get(_conversationsEndpoint);
      final payload = data is Map<String, dynamic> && data['data'] is List
          ? data['data']
          : data;
      if (payload is List) {
        final list = <ConversationModel>[];
        for (final item in payload) {
          if (item is Map<String, dynamic>) {
            list.add(ConversationModel.fromJson(item));
          }
        }
        conversations.assignAll(list);
      }
    });
  }

  void fetchChatDetails({
    int limit = 30,
    int page = 1,
    bool prepend = false,
  }) {
    final socket = _socket;
    if (socket == null) return;
    _prependNext = prepend;
    socket.add(
      jsonEncode({"type": "fetch_chat", "page": page, "page_size": limit}),
    );
  }

  Future<void> markAsRead(String conversationId) async {
    await apiCall(() async {
      await _api.post('$_conversationsEndpoint$conversationId/read/');
    }, showLoading: false);
  }

  void _onSocketData(dynamic payload) {
    final data = _decodeSocketPayload(payload);
    if (data == null) return;

    final type = data['type'];
    final body = data['data'];

    if (type == 'chat_details' && body is Map<String, dynamic>) {
      _handleChatDetails(body);
      return;
    }

    if ((type == 'new_message' || type == 'message_ack') &&
        body is Map<String, dynamic>) {
      final message = _messageFromDynamic(body);
      if (message != null) {
        _upsertMessage(message);
      }
    }
  }

  void _onSocketDone() {
    isSocketConnected.value = false;
  }

  void _onSocketError(Object error) {
    isSocketConnected.value = false;
    AppLogger.error('Socket error', error: error);
  }

  Map<String, dynamic>? _decodeSocketPayload(dynamic payload) {
    try {
      if (payload is String) {
        final decoded = jsonDecode(payload);
        return decoded is Map<String, dynamic> ? decoded : null;
      }
      if (payload is Map<String, dynamic>) return payload;
    } catch (e, st) {
      AppLogger.error('Socket decode error', error: e, stackTrace: st);
    }
    return null;
  }

  void _handleChatDetails(Map<String, dynamic> data) {
    final participantsList = data['participants'];
    if (participantsList is List) {
      participants.assignAll(
        participantsList.whereType<Map<String, dynamic>>(),
      );
      _rebuildRoles();
    }

    final messagesList = data['messages'];
    final parsed = _parseMessages(messagesList);
    if (_prependNext && messages.isNotEmpty) {
      messages.assignAll(<MessageModel>[...parsed, ...messages]);
    } else {
      messages.assignAll(parsed);
    }
    _prependNext = false;
    _rebuildMessageIndex();

    final paging = data['paging'];
    if (paging is Map<String, dynamic>) {
      hasNext.value = paging['has_next'] == true;
      currentPage.value = paging['page'] is int ? paging['page'] : 1;
    }
  }

  List<MessageModel> _parseMessages(dynamic raw) {
    if (raw is! List) return const <MessageModel>[];
    final list = <MessageModel>[];
    for (final item in raw) {
      if (item is Map<String, dynamic>) {
        final message = _messageFromDynamic(item);
        if (message != null) list.add(message);
      }
    }
    return list;
  }

  MessageModel? _messageFromDynamic(Map<String, dynamic> data) {
    final senderId = data['sender_id'];
    if (data['role'] == null && senderId is int) {
      data = Map<String, dynamic>.from(data);
      data['role'] =
          _roleByUserId[senderId] ??
          (_currentUserId == senderId ? _currentUserRole : null) ??
          'unknown';
    }
    try {
      return MessageModel.fromJson(data);
    } catch (e, st) {
      AppLogger.error('Message parse failed', error: e, stackTrace: st);
      return null;
    }
  }

  void _upsertMessage(MessageModel message) {
    final index = _messageIndexById[message.id];
    if (index != null) {
      messages[index] = message;
      return;
    }
    messages.add(message);
    _messageIndexById[message.id] = messages.length - 1;
  }

  void _rebuildMessageIndex() {
    _messageIndexById.clear();
    for (var i = 0; i < messages.length; i++) {
      _messageIndexById[messages[i].id] = i;
    }
  }

  void _rebuildRoles() {
    _roleByUserId.clear();
    for (final p in participants) {
      final id = p['user_id'];
      final role = p['role'];
      if (id is int && role is String) {
        _roleByUserId[id] = role;
      }
    }
  }

  String _buildWsUrl(String roomId, String token) {
    final base = EnvironmentConfig.imageUrl;
    final uri = Uri.parse(base);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return uri
        .replace(
          scheme: scheme,
          path: '/ws/chat/$roomId/',
          queryParameters: {'token': token},
        )
        .toString();
  }

  @override
  void onClose() {
    disconnectSocket();
    super.onClose();
  }
}
