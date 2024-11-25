import 'package:flutter/material.dart';

import '../../domain/entities/student.dart';
import 'avatar.dart';

class StudentListTile extends StatelessWidget {
  final Student student;

  const StudentListTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Avatar(avatarUrl: student.avatar, status: 'OFFLINE'),
      title: Text(student.fullName.length > 10 ? student.fullName.substring(0, 10) + '...' : student.fullName),
      subtitle: Text(student.joinSince),
      onTap: () => Navigator.pushNamed(
        context,
        '/chat',
        arguments: {
          'receiverId': student.id,
          'avatar': student.avatar,
          'fullName': student.fullName,
          'joinSince': student.joinSince,
          'status': 'OFFLINE'
        },
      ),
    );
  }
}