import 'package:chat_app_client/features/chat/domain/usecases/report_user.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final int userId;

  const ChatBubble(
      {super.key,
        required this.message,
        required this.isCurrentUser,
        required this.userId,
        required this.messageId});

  // show options
  void _showOptions(BuildContext context, String messageId, int user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text("Report"),
                  onTap: () {
                    Navigator.pop(context);
                    _reportMessage(context, messageId, userId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _blockUser(context, userId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: () => Navigator.pop(context),
                )
              ],
            ));
      },
    );
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Message"),
        content: const Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                context.read<UserBloc>().add(ReportUserEvent(reportUserId: userId,reason: 'spam'));
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Message Reported")));
              },
              child: const Text("Report"))
        ],
      ),
    );
  }

  void _blockUser(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                context.read<UserBloc>().add(BlockUserEvent(userId));
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("User has been block")));
              },
              child: const Text("Block"))
        ],
      ),
    );
  }


  // block user
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isCurrentUser ? Colors.green : Colors.grey.shade500),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
