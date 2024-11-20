import 'dart:developer';

import 'package:chat_app_client/core/components/my_drawer.dart';
import 'package:chat_app_client/core/socket_service.dart';
import 'package:chat_app_client/features/chat/domain/entities/user.dart';
import 'package:chat_app_client/features/chat/domain/repositories/student_repository.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/student/student_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListPage extends StatelessWidget {
  final SocketService? socketService;

  const UserListPage({super.key, this.socketService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      drawer: MyDrawer(),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            return ListView.builder(
              itemCount: state.message.length,
              itemBuilder: (context, index) {
                final student = state.message[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(student.avatar),
                  ),
                  title: Text(student.fullName),
                  subtitle: Text('Joined ${student.joinSince}'),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: {'receiverId': student.id},
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}