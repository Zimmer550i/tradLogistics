class MessageModel {
  final int id;
  final int senderId;
  final String role;
  final String text;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.role,
    required this.text,
    required this.createdAt,
    this.deliveredAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      role: json['role'],
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'role': role,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }
}