import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int senderId;
  final int receiverId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const Message({required this.senderId,
    required this.receiverId,
    required this.message,
    required this.isRead,
    required this.createdAt,});

  @override
  List<Object?> get props => [senderId, receiverId, message, isRead, createdAt];
}