import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int senderId;
  final int receiverId;
  final String message;
  final bool isRead;

  const Message({required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,});

  @override
  List<Object?> get props => [senderId, receiverId, message, isRead];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      isRead: json['isRead']
    );
  }
}