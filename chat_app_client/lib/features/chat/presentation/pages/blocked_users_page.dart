import 'dart:developer';

import 'package:chat_app_client/features/chat/presentation/bloc/blockeduser/blockeduser_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/chat/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user/user_bloc.dart';

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
                  BlocProvider.of<BlockeduserBloc>(context)
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

    BlocProvider.of<BlockeduserBloc>(context).add(GetBlockedUsersEvent());
    loadUserId();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacementNamed(context, '/users'),
          ),
          title: const Text(
            'Blocked Users',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueAccent),
          )),
      body: BlocBuilder<BlockeduserBloc, BlockeduserState>(
        builder: (context, state) {
          if (state is BlockLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlockLoaded) {
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
          } else if (state is BlockError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
