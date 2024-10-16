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
  late String? username;

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
      username = arguments['username'];
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
      appBar: AppBar(
        backgroundColor: Colors.white,
          leadingWidth: 75,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () => Navigator.pop(context),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back),
                  CircleAvatar(
                      backgroundColor: Colors.black87,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(username!),
            ],
          )),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFF0F4F8), Color(0xFFE5E9ED)],
            begin: Alignment.topLeft,
            end:  Alignment.bottomRight
          )
        ),
        child: Column(
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
                      return Align(
                        alignment: message.receiverId != userData
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Column(
                            crossAxisAlignment: message.receiverId != userData
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                    borderRadius: message.receiverId == userData
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                            bottomLeft: Radius.circular(16))
                                        : const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                            bottomRight: Radius.circular(16)),
                                    color: message.receiverId != userData
                                        ? const Color(0xFF0096C7)
                                        : const Color(0xFF48CAE4)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.message,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          fillColor: const Color(0xFFC2D6FF),
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.grey),
                          hintText: 'Type a message',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Color(0xFFC2D6FF))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.grey))),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: const Color(0xFF3188FF),
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
      ),
    );
  }
}
