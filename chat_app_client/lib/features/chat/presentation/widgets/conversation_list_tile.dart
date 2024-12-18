import 'package:chat_app_client/features/chat/data/models/conversation.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversationListTile extends StatelessWidget {
  final Conversation conversation;

  const ConversationListTile({super.key, required this.conversation});

  String _formatTimestamp(String timestamp) {
    // Parse the timestamp as UTC and add 7 hours for GMT+7
    final messageDate =
        DateTime.parse(timestamp).toUtc().add(const Duration(hours: 7));
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));

    // Check if the message is from today
    if (messageDate.year == now.year &&
        messageDate.month == now.month &&
        messageDate.day == now.day) {
      return DateFormat('HH:mm').format(messageDate); // Format: 17:12
    }

    // If the message is from the same week
    final difference = now.difference(messageDate).inDays;
    if (difference < 7) {
      return DateFormat('EEEE').format(messageDate); // Format: Tuesday
    }

    // Else display in dd/MM/yy format
    return DateFormat('dd/MM/yy').format(messageDate); // Format: 17/12/24
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Avatar(avatarUrl: conversation.avatar, status: conversation.status),
      title: Row(
        children: [
          Text(conversation.fullName.length > 16
              ? '${conversation.fullName.substring(0, 16)}...'
              : conversation.fullName),
          const Spacer(),
          Text(
            _formatTimestamp(conversation.lastMessageTimestamp),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          if (conversation.isMessageSeen) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.done_all,
              size: 16,
              color: Colors.blue,
            ),
          ],
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              conversation.lastMessage,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
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
