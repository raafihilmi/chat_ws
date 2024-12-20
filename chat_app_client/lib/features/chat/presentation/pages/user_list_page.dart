import 'dart:developer';

import 'package:chat_app_client/core/components/my_drawer.dart';
import 'package:chat_app_client/features/chat/domain/entities/user.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  void _showBottomSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block'),
                onTap: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<UserBloc>(context)
                      .add(BlockUserEvent(user.id));
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                onTap: () {
                  Navigator.of(context).pop();
                  BlocProvider.of<UserBloc>(context).add(
                      ReportUserEvent(reason: 'Spam', reportUserId: user.id));
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
    BlocProvider.of<UserBloc>(context)
        .add(const GetAvailableUsersEvent());

    loadUserId();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
          title: const Text(
        'ChatApp',
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent),
      )),
        drawer: MyDrawer(),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            BlocProvider.of<UserBloc>(context)
                .add(const GetAvailableUsersEvent());
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
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
                  onTap: () {
                    Navigator.pushNamed(context, '/chat', arguments: {
                      'selectedUser': user.id,
                      'userId': userId,
                      'username': user.username
                    });
                  },
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
