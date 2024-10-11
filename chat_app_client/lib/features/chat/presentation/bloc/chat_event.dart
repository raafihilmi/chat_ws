part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadChatHistory extends ChatEvent {
  final int userId;

  const LoadChatHistory({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}

class SendMessage extends ChatEvent {
  final int receiverId;
  final String message;

  const SendMessage({required this.receiverId, required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [receiverId, message];
}
