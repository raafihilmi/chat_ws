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

class InitializeChatEvent extends ChatEvent {
  final String receiverId;

  const InitializeChatEvent(this.receiverId);

  @override
  List<Object> get props => [receiverId];
}

class MarkMessageAsSeenEvent extends ChatEvent {
  final String messageId;

  const MarkMessageAsSeenEvent(this.messageId);

  @override
  List<Object> get props => [messageId];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final String receiverId;

  const SendMessageEvent(this.message, this.receiverId);

  @override
  List<Object> get props => [message,receiverId];
}

class SetTypingStatusEvent extends ChatEvent {
  final bool isTyping;
  final String receiverId;

  const SetTypingStatusEvent(this.receiverId, this.isTyping);

  @override
  List<Object> get props => [receiverId, isTyping];
}

class LoadChatHistory extends ChatEvent {
  final int userId;

  const LoadChatHistory({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
