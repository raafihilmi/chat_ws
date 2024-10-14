import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required int senderId,
    required int receiverId,
    required String message,
    required bool isRead,
  }) : super(
    senderId: senderId,
    receiverId: receiverId,
    message: message,
    isRead: isRead,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      isRead: json['is_read'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'is_read': isRead,
    };
  }
}