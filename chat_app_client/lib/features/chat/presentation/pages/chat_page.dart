import 'dart:async';
import 'package:chat_app_client/core/components/message_bubble.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  Timer? _typingTimer;
  String? _receiverId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _receiverId = args['receiverId'];

    context.read<ChatBloc>().add(InitializeChatEvent(_receiverId!));
  }

  void _handleTyping() {
    _typingTimer?.cancel();
    context.read<ChatBloc>().add(
      SetTypingStatusEvent(_receiverId!, true),
    );

    _typingTimer = Timer(Duration(seconds: 2), () {
      context.read<ChatBloc>().add(
        SetTypingStatusEvent(_receiverId!, false),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatMessageLoaded) {
                  return ListView.builder(
                    itemCount: state.message.length,
                    itemBuilder: (context, index) {
                      final message = state.message[index];
                      return MessageBubble(message: message);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (_) => _handleTyping(),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      context.read<ChatBloc>().add(
                        SendMessageEvent(
                          _receiverId!,
                          _messageController.text,
                        ),
                      );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }
}
