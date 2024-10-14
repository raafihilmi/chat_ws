part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ConnectToChatEvent extends ChatEvent {
  final int currentUserId;
  final int otherUserId;

  const ConnectToChatEvent(this.currentUserId, this.otherUserId);

  @override
  List<Object> get props => [currentUserId, otherUserId];
}

class SendMessageEvent extends ChatEvent {
  final Message message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class LoadChatHistory extends ChatEvent {
  final int userId;

  const LoadChatHistory({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
