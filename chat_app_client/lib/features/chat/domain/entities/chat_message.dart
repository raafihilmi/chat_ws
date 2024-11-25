class ChatMessage {
  final String id;
  final String fullName;
  final String avatar;
  final String status;
  final String messageId;
  final String message;
  final DateTime messageTimestamp;
  final bool isMessageSeen;
  final bool isMessageFromCurrentUser;

  ChatMessage({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.status,
    required this.messageId,
    required this.message,
    required this.messageTimestamp,
    required this.isMessageSeen,
    required this.isMessageFromCurrentUser,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      avatar: json['avatar'] ?? '',
      status: json['status'] ?? '',
      messageId: json['message_id'] ?? '',
      message: json['message'] ?? '',
      messageTimestamp: json['message_timestamp'] != null
          ? DateTime.parse(json['message_timestamp'])
          : DateTime.now(),
      isMessageSeen: json['is_message_seen'] ?? false,
      isMessageFromCurrentUser: json['is_message_from_current_user'] ?? false,
    );
  }
}
