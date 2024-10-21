import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_bloc.dart';

class BlockedUsersPage extends StatelessWidget {
  const BlockedUsersPage({super.key});

  void _showBottomSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Unblock'),
                onTap: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<UserBloc>(context)
                      .add(UnblockUserEvent(user.id));
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    late int? userId;
    Future<void> loadUserId() async {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getInt('auth_uid');
      log(userId.toString(), name: 'UID');
    }

    loadUserId();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Blocked Users',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          )),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            BlocProvider.of<UserBloc>(context)
                .add(const GetBlockedUsersEvent());
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserInitial) {
            BlocProvider.of<UserBloc>(context)
                .add(const GetBlockedUsersEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return state.users.isEmpty
                ? const Center(child: Text('No blocked users'))
                : ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  tileColor: Colors.white,
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.email),
                  onLongPress: () => _showBottomSheet(context, user),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}