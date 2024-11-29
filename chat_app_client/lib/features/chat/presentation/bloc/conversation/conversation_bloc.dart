import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/conversation.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/student_repository.dart';

part 'conversation_event.dart';

part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final StudentRepository _repository;
  StreamSubscription? _conversationSubscription;


  ConversationBloc(this._repository) : super(ConversationInitial()) {
    on<GetConversationEvent>(_onGetConversation);
    on<UpdateConversationEvent>(_onUpdateConversation);
  }

  Future<void> _onGetConversation(
    GetConversationEvent event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      emit(ConversationLoading());
      final students = await _repository.getConversation();
      print('Students found: $students');
      emit(ConversationLoaded(students));
      _conversationSubscription?.cancel();
      _conversationSubscription = _repository.getConversationStream().listen(
            (updatedConversations) {
          add(UpdateConversationEvent(updatedConversations));
        },
      );
    } catch (e) {
      print('Error getting conversation students: $e');
      emit(ConversationError(e.toString()));
    }
  }

  void _onUpdateConversation(
      UpdateConversationEvent event,
      Emitter<ConversationState> emit,
      ) {
    emit(ConversationLoaded(event.conversations));
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    _repository.dispose();
    return super.close();
  }
}
