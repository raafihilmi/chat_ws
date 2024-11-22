import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_client/core/components/message_bubble.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat/chat_bloc.dart';
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
                CircleAvatar(
                  child: _receiverAvatar!.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: _receiverAvatar!,
                            placeholder: (context, url) => const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.person),
                ),
              ],
            ),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(_receiverFullName!),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatMessageLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.message.length,
                    itemBuilder: (context, index) {
                      final message = state.message[index];
                      return MessageBubble(message: message);
                    },
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (_) => _handleTyping(),
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
