import 'dart:async';

import 'package:chat_app_client/features/chat/domain/entities/chat_message.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';


part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(ChatInitial()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessageAsSeenEvent>(_onMarkMessageAsSeen);
    on<SetTypingStatusEvent>(_onSetTypingStatus);
  }

  StreamSubscription? _chatSubscription;

  Future<void> _onInitializeChat(
      InitializeChatEvent event,
      Emitter<ChatState> emit,
      ) async {
    await _chatSubscription?.cancel();
    _chatSubscription = _repository
        .getChatMessages(event.receiverId)
        .listen((messages) {
      emit(ChatMessageLoaded(messages));
    });
  }

  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      await _repository.sendMessage(event.receiverId, event.message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onMarkMessageAsSeen(
      MarkMessageAsSeenEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      await _repository.markMessageAsSeen(event.messageId);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSetTypingStatus(
      SetTypingStatusEvent event,
      Emitter<ChatState> emit,
      ) async {
    try {
      await _repository.setTypingStatus(event.receiverId, event.isTyping);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}