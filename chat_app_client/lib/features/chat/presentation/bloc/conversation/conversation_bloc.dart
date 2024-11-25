import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/conversation.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/student_repository.dart';

part 'conversation_event.dart';

part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final StudentRepository _repository;

  ConversationBloc(this._repository) : super(ConversationInitial()) {
    on<GetConversationEvent>(_onGetConversation);
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
    } catch (e) {
      print('Error getting conversation students: $e');
      emit(ConversationError(e.toString()));
    }
  }
}
