import 'dart:async';
import 'package:chat_app_client/core/components/message_bubble.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/core/components/message_date_header.dart';

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
        curve: Curves.easeInOut,
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
      backgroundColor: const Color(0xffFFFFFF),
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 75,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  Avatar(
                      avatarUrl: _receiverAvatar!, status: _receiverStatus!)
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
                          : Colors.grey,
                    ),
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

                DateTime? lastMessageDate; // Track the last message date

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

                        // Extract just the year, month, and day from the timestamp
                        final messageDate = DateTime(
                          message.messageTimestamp.year,
                          message.messageTimestamp.month,
                          message.messageTimestamp.day,
                        );

                        final showDateHeader = lastMessageDate == null ||
                            messageDate.isAfter(lastMessageDate!);

                        lastMessageDate = messageDate;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showDateHeader)
                              MessageDateHeader(date: message.messageTimestamp),
                            MessageBubble(message: message),
                          ],
                        );
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
                      fillColor: const Color(0xFFFFFFFF),
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: 'Ketik Pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey, // Light grey border
                          width: 1.5, // Stroke width for enabled state
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xff4E74ED), // Light grey border
                          width: 2.0, // Stroke width for focused state
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color(0xff4E74ED),
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
