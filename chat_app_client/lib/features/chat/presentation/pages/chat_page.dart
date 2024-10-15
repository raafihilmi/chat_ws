import 'dart:developer';

import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];
  late int? userData;
  late int? userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      userId = arguments['userId'];
      userData = arguments['selectedUser'];
      log('Connecting to chat with user: $userData');
      BlocProvider.of<ChatBloc>(context).add(
        ConnectToChatEvent(userId!, userData!),
      );
    } else {
      log('Error: userData is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatConnected) {
                  log(state.toString(), name: 'ChatPage');
                }
                if (state is MessageReceived) {
                  log(state.message.message, name: 'ChatPage');
                  setState(() {
                    _messages.add(state.message);
                  });
                } else if (state is ChatError) {
                  log(state.message, name: 'ChatPage Error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    log(message.message, name: 'ChatPage build');
                    log(message.receiverId.toString(), name: 'RecID');
                    log(userData.toString(), name: 'udID');
                    return ListTile(
                      title: Text(message.message),
                      subtitle: Text(
                          message.receiverId != userData ? 'Other' : 'You'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty &&
                        userData != null) {
                      final message = Message(
                        senderId: userId!,
                        receiverId: userData!,
                        message: _messageController.text,
                        isRead: false,
                      );
                      BlocProvider.of<ChatBloc>(context)
                          .add(SendMessageEvent(message));
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
}
