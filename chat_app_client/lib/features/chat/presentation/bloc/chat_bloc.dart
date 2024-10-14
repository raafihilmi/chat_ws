import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/connect_to-cat.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectToChat connectToChat;
  final SendMessage sendMessage;

  ChatBloc(this.connectToChat, this.sendMessage) : super(ChatInitial()) {
    on<ConnectToChatEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await emit.forEach<Message>(
          connectToChat.execute(event.currentUserId, event.otherUserId),
          onData: (message) {
            log('Message received: ${message.message}');
            return MessageReceived(message);
          },
        );
      } catch (e) {
        emit(ChatError('Failed to connect to chat'));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      final result = await sendMessage.execute(event.message);
      result.fold(
        (failure) => emit(ChatError('Failed to send message')),
        (_) => emit(state),
      );
    });
  }
}
