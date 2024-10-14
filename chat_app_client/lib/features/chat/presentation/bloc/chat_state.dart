part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatConnected extends ChatState {}

class MessageReceived extends ChatState {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}