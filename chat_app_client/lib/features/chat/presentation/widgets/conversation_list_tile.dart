import 'package:chat_app_client/features/chat/data/models/conversation.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationListTile extends StatelessWidget {
  final Conversation conversation;

  const ConversationListTile({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Avatar(
          avatarUrl: conversation.avatar,
          status: conversation.status
      ),
      title: Row(
        children: [
          Text(conversation.fullName.length > 16 ? conversation.fullName.substring(0, 16) + '...' : conversation.fullName),
          const Spacer(),
          Text(
            timeago.format(
                DateTime.parse(conversation.lastMessageTimestamp),
                allowFromNow: true
            ),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
      subtitle: Row(
        children: [
          if (conversation.isMessageSeen) ...[
            const SizedBox(width: 4),
            Icon(
              conversation.isMessageSeen ? Icons.done_all : Icons.done,
              size: 16,
              color: conversation.isMessageSeen ? Colors.blue : Colors.grey,
            ),
          ],
          const SizedBox(width: 5),
          Text(conversation.lastMessage),
        ],
      ),
      onTap: () => Navigator.pushNamed(
        context,
        '/chat',
        arguments: {
          'receiverId': conversation.id,
          'avatar': conversation.avatar,
          'fullName': conversation.fullName,
          'joinSince': conversation.joinSince,
          'status': conversation.status
        },
      ),
    );
  }
}