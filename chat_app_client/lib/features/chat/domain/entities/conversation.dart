class ConversationModel {
  int code;
  String status;
  String message;
  Data data;

  ConversationModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

}

class Data {
  List<Conversation> conversations;

  Data({
    required this.conversations,
  });

}

class Conversation {
  String id;
  String fullName;
  String avatar;
  String status;
  String joinSince;
  String lastMessage;
  DateTime lastMessageTimestamp;
  bool isMessageSeen;
  bool isMessageFromCurrentUser;
  int totalUnreadMessages;

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

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["id"],
    fullName: json["full_name"],
    avatar: json["avatar"],
    status: json["status"],
    joinSince: json["join_since"],
    lastMessage: json["last_message"],
    lastMessageTimestamp: DateTime.parse(json["last_message_timestamp"]),
    isMessageSeen: json["is_message_seen"],
    isMessageFromCurrentUser: json["is_message_from_current_user"],
    totalUnreadMessages: json["total_unread_messages"],
  );

}
