import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasources/chat_remote_data_source.dart';
import '../../../domain/usecases/connect_to_chat.dart';
import '../../../domain/usecases/send_message.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectToChat connectToChat;
  final SendMessage sendMessage;
  final List<Message> messages = [];


  ChatBloc(this.connectToChat, this.sendMessage) : super(ChatInitial()) {
    on<ConnectToChatEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        await emit.forEach<Message>(
          connectToChat.execute(event.currentUserId, event.otherUserId),
          onData: (message) {
            log('Message received: ${message.message}');
            messages.add(message);
            return MessageReceived(message);
          },
        );
      } catch (e) {
        log('Error connecting to chat: $e');
        emit(ChatError('Failed to connect to chat'));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      log('Sending message in bloc: ${event.message.message}');
      final result = await sendMessage.execute(event.message);
      result.fold(
        (failure) {
          log('Failed to send message: $failure');
          emit(ChatError('Failed to send message'));
        },
        (_) {
          log('Message sent successfully ${event.message}');
          messages.add(event.message);
          emit(MessageReceived(event.message));
        },
      );
    });
  }
}
