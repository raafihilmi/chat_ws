import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const LoadChatHistory(userId: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChatLoaded) {
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: state.message.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(state.message[index]);
                      },
                    )),
                _buildMessageInput(),
              ],
            );
          } else if (state is ChatError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const Center(
            child: Text('Star a conversation'),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.senderId == 1 ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.senderId == 1 ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.message),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(hintText: 'Type a message'),
              )),
          IconButton(onPressed: () {
            if (_messageController.text.isNotEmpty) {
              context.read<ChatBloc>().add(SendMessage(
                  receiverId: 2, message: _messageController.text));
              _messageController.clear();
            }
          }, icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
