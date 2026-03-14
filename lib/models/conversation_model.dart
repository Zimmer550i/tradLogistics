class ConversationModel {
  final int id;
  final String publicId;
  final int? deliveryId;
  final DateTime? createdAt;
  final ConversationUser? otherUser;
  final ConversationLastMessage? lastMessage;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.publicId,
    this.deliveryId,
    this.createdAt,
    this.otherUser,
    this.lastMessage,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: _asInt(json['id']) ?? 0,
      publicId: json['public_id']?.toString() ?? '',
      deliveryId: _asInt(json['delivery']),
      createdAt: _asDate(json['created_at']),
      otherUser: json['other_user'] is Map<String, dynamic>
          ? ConversationUser.fromJson(
              json['other_user'] as Map<String, dynamic>,
            )
          : null,
      lastMessage: json['last_message'] is Map<String, dynamic>
          ? ConversationLastMessage.fromJson(
              json['last_message'] as Map<String, dynamic>,
            )
          : null,
      unreadCount: _asInt(json['unread_count']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'public_id': publicId,
      'delivery': deliveryId,
      'created_at': createdAt?.toIso8601String(),
      'other_user': otherUser?.toJson(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
    };
  }
}

class ConversationUser {
  final int userId;
  final String name;
  final String? phone;
  final String? role;
  final String? profileImage;

  ConversationUser({
    required this.userId,
    required this.name,
    this.phone,
    this.role,
    this.profileImage,
  });

  factory ConversationUser.fromJson(Map<String, dynamic> json) {
    return ConversationUser(
      userId: _asInt(json['user_id']) ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString(),
      profileImage: json['profile_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'phone': phone,
      'role': role,
      'profile_image': profileImage,
    };
  }
}

class ConversationLastMessage {
  final int id;
  final int? conversationId;
  final int? senderId;
  final String? senderName;
  final String? senderRole;
  final String? senderAvatar;
  final String text;
  final DateTime? createdAt;

  ConversationLastMessage({
    required this.id,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.senderRole,
    this.senderAvatar,
    required this.text,
    this.createdAt,
  });

  factory ConversationLastMessage.fromJson(Map<String, dynamic> json) {
    return ConversationLastMessage(
      id: _asInt(json['id']) ?? 0,
      conversationId: _asInt(json['conversation']),
      senderId: _asInt(json['sender']),
      senderName: json['sender_name']?.toString(),
      senderRole: json['sender_role']?.toString(),
      senderAvatar: json['sender_avatar']?.toString(),
      text: json['text']?.toString() ?? '',
      createdAt: _asDate(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation': conversationId,
      'sender': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'sender_avatar': senderAvatar,
      'text': text,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _asDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
