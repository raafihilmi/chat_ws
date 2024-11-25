class Conversation {
  final String id;
  final String fullName;
  final String avatar;
  final String status;
  final String joinSince;
  final String lastMessage;
  final String lastMessageTimestamp;
  final bool isMessageSeen;
  final bool isMessageFromCurrentUser;
  final int totalUnreadMessages;

  Conversation({
    required this.id,
    required this.fullName,
    required this.avatar,
    required this.status,
    required this.joinSince,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.isMessageSeen,
    required this.isMessageFromCurrentUser,
    required this.totalUnreadMessages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      fullName: json['full_name'],
      avatar: json['avatar']  ?? '',
      status: json['status'],
      joinSince: json['join_since'],
      lastMessage: json['last_message'],
      lastMessageTimestamp: json['last_message_timestamp'],
      isMessageSeen: json['is_message_seen'],
      isMessageFromCurrentUser: json['is_message_from_current_user'],
      totalUnreadMessages: json['total_unread_messages'],
    );
  }
}
