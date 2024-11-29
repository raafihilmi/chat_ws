import 'package:chat_app_client/core/components/my_drawer.dart';
import 'package:chat_app_client/core/socket_service.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/student/student_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/conversation_list_tile.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/search_bar.dart';
import 'package:chat_app_client/features/chat/presentation/widgets/student_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class UserListPage extends StatefulWidget {
  final SocketService? socketService;

  const UserListPage({super.key, this.socketService});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(GetConversationEvent(''));
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      context.read<ConversationBloc>().add(GetConversationEvent(''));
    } else {
      setState(() {
        _isSearching = true;
      });
      context.read<StudentBloc>().add(GetStudentsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        forceMaterialTransparency: true,
        title: const Text('Chat'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MySearchBar(
              onSearch: _handleSearch,
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: _isSearching ? _buildSearchResults() : _buildConversationList(),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StudentLoaded) {
          if(state.message.isEmpty) {
            return const Center(child: Text('Tidak ada pengguna'));
          }
          return ListView.builder(
                  itemCount: state.message.length,
                  itemBuilder: (context, index) {
                    final student = state.message[index];
                    return StudentListTile(student: student);
                  },
                );
        }

        if (state is StudentError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildConversationList() {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        if (state is ConversationLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ConversationLoaded) {
          return ListView.builder(
            itemCount: state.message.length,
            itemBuilder: (context, index) {
              final conversation = state.message[index];
              return ConversationListTile(conversation: conversation);
            },
          );
        }

        if (state is ConversationError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
