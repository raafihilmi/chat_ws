part of 'conversation_bloc.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}


class GetConversationEvent extends ConversationEvent {
  final String search;

  const GetConversationEvent(this.search);

  @override
  List<Object> get props => [search];
}

class UpdateConversationEvent extends ConversationEvent {
  final List<Conversation> conversations;

  UpdateConversationEvent(this.conversations);

  @override
  List<Object?> get props => [conversations];
}