class ChatMessage {
  final String id;
  final String fullName;
  final String avatar;
  final String messageId;
  final String message;
  final DateTime messageTimestamp;
  final bool isMessageSeen;
  final bool isMessageFromCurrentUser;

  ChatMessage({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.messageId,
    required this.message,
    required this.messageTimestamp,
    required this.isMessageSeen,
    required this.isMessageFromCurrentUser,
  });
}