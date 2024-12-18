import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.senderId,
    required super.receiverId,
    required super.message,
    required super.isRead,
  });

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