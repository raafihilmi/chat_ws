import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:chat_app_client/features/chat/domain/usecases/get_chat_history_usecase.dart';
import 'package:chat_app_client/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatHistoryUseCase getChatHistoryUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(
      {required this.getChatHistoryUseCase, required this.sendMessageUseCase})
      : super(ChatInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadChatHistory(
      LoadChatHistory event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await getChatHistoryUseCase(event.userId);
    log(result as String, name: "LOADCHAT");
    result.fold(
      (failure) =>
          emit(ChatError(message: 'Failed to load chat history: $failure')),
      (message) => emit(ChatLoaded(message: message)),
    );
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final result = await sendMessageUseCase(SendMessageParams(
          receiverId: event.receiverId, message: event.message));
      result.fold(
        (failure) =>
            emit(ChatError(message: 'Failed to send message: $failure')),
        (sentMessage) => emit(ChatLoaded(
            message: List.from(currentState.message)..add(sentMessage))),
      );
    }
  }
}
