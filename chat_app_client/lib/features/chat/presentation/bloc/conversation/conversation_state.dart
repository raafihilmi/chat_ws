part of 'conversation_bloc.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationConnected extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<Conversation> message;

  const ConversationLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceived extends ConversationState {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}