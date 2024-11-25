import 'dart:async';
import 'package:chat_app_client/core/components/message_bubble.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;
  String? _receiverId;
  String? _receiverAvatar;
  String? _receiverFullName;
  String? _receiverJoinSince;
  String? _receiverStatus;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _receiverId = args['receiverId'];
    _receiverAvatar = args['avatar'];
    _receiverFullName = args['fullName'];
    _receiverJoinSince = args['joinSince'];
    _receiverStatus = args['status'];

    context.read<ChatBloc>().add(InitializeChatEvent(_receiverId!));
  }

  void _handleTyping() {
    _typingTimer?.cancel();
    context.read<ChatBloc>().add(
          SetTypingStatusEvent(_receiverId!, true),
        );

    _typingTimer = Timer(const Duration(seconds: 2), () {
      context.read<ChatBloc>().add(
            SetTypingStatusEvent(_receiverId!, false),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 75,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                Avatar(avatarUrl: _receiverAvatar!, status: _receiverStatus!)
              ],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(_receiverFullName!),
            Row(
              children: [
                Text(
                  _receiverStatus!,
                  style: TextStyle(
                      fontSize: 10,
                      color: _receiverStatus == 'ONLINE'
                          ? Colors.green
                          : Colors.grey),
                ),
                Text(
                  " - Bergabung Sejak $_receiverJoinSince",
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ChatMessageLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
                return Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.message.length,
                      itemBuilder: (context, index) {
                        final message = state.message[index];
                        return MessageBubble(message: message);
                      },
                    ),
                  ),
                );
              }
              if (state is ChatError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }
              return const Center(child: Text("Error bos"));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (_) {
                      _handleTyping();
                      _scrollToBottom();
                    },
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
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
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }
}
