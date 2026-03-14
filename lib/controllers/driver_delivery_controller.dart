import 'dart:async';

import 'package:get/get.dart';
import 'package:template/controllers/base_controller.dart';
import 'package:template/controllers/user_profile_controller.dart';
import 'package:template/models/delivery_model.dart';
import 'package:template/network/api_endpoints.dart';
import 'package:template/network/base_api_service.dart';

class DriverDeliveryController extends BaseController {
  final _api = BaseApiService();
  final user = Get.find<UserProfileController>();

  RxBool isOnline = RxBool(false);
  final Rx<DeliveryModel?> currentDelivery = Rx(null);
  final RxList<DeliveryModel> ongoingDeliveries = <DeliveryModel>[].obs;
  Timer? _onlinePoller;

  DeliveryModel get data => currentDelivery.value!;

  bool get isOngoing {
    final delivery = currentDelivery.value;
    if (delivery == null) {
      return false;
    }
    switch (delivery.status) {
      case Status.driverAssigned:
      case Status.pickedUp:
      case Status.inTransit:
        return true;
      case Status.pending:
      case Status.searching:
      case Status.delivered:
      case Status.cancelled:
        return false;
    }
  }

  Future<void> fetchAvailableDelivery() async {
    await apiCall(() async {
      final data = await _api.get(ApiEndpoints.driverAvailableDeliveries);
      final payload = data is Map<String, dynamic> && data['data'] is List
          ? data['data']
          : data;
      if (payload is List && payload.isNotEmpty) {
        currentDelivery.value = DeliveryModel.fromJson(
          payload.first as Map<String, dynamic>,
        );
      } else {
        currentDelivery.value = null;
      }
    }, showLoading: false);
  }

  Future<void> toggleAvailability() async {
    await apiCall(() async {
      final data = await _api.multipart(
        'PATCH',
        ApiEndpoints.updateUserProfile,
        fields: {'is_online': "${!isOnline.value}"},
      );

      user.data.isOnline = data['data']['is_online'];
      isOnline.value = data['data']['is_online'];
      _handleOnlineStatus(isOnline.value);
    }, showOverlay: true);
  }

  void _handleOnlineStatus(bool online) {
    if (online) {
      _startOnlinePolling();
    } else {
      _stopOnlinePolling();
    }
  }

  void _startOnlinePolling() {
    _onlinePoller?.cancel();
    _onlinePoller = Timer.periodic(
      const Duration(seconds: 5),
      (_) => fetchAvailableDelivery(),
    );
    fetchAvailableDelivery();
  }

  void _stopOnlinePolling() {
    _onlinePoller?.cancel();
    _onlinePoller = null;
  }

  @override
  void onClose() {
    _stopOnlinePolling();
    super.onClose();
  }

  Future<void> acceptDelivery(String id) async {
    return apiCall(() async {
      final endpoint = '${ApiEndpoints.driverDeliveries}$id/accept/';
      await _api.post(endpoint);
      // final updated = DeliveryModel.fromJson(data['data']);
      currentDelivery.value!.status = Status.driverAssigned;
      _stopOnlinePolling();
    }, showOverlay: true);
  }

  void declineDelivery() async {
    currentDelivery.value = null;
  }

  Future<void> fetchOngoingDeliveries() async {
    await apiCall(() async {
      final data = await _api.get(ApiEndpoints.ongoingDeliveries);
      ongoingDeliveries.assignAll(_parseDeliveryList(data));
    });
  }

  List<DeliveryModel> _parseDeliveryList(dynamic data) {
    final payload = data is Map<String, dynamic> && data['data'] is List
        ? data['data']
        : data;
    if (payload is! List) {
      return const <DeliveryModel>[];
    }
    return payload
        .whereType<Map<String, dynamic>>()
        .map(DeliveryModel.fromJson)
        .toList();
  }
}
