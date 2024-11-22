  import 'dart:io';

import 'package:chat_app_client/features/authentication/presentation/bloc/auth_bloc.dart';
  import 'package:chat_app_client/features/authentication/presentation/pages/auth_gate.dart';
  import 'package:chat_app_client/features/authentication/presentation/pages/login_page.dart';
  import 'package:chat_app_client/features/authentication/presentation/pages/register_page.dart';
  import 'package:chat_app_client/features/chat/presentation/bloc/blockeduser/blockeduser_bloc.dart';
  import 'package:chat_app_client/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/student/student_bloc.dart';
  import 'package:chat_app_client/features/chat/presentation/bloc/user/user_bloc.dart';
  import 'package:chat_app_client/features/chat/presentation/pages/blocked_users_page.dart';
  import 'package:chat_app_client/features/chat/presentation/pages/chat_page.dart';
  import 'package:chat_app_client/features/chat/presentation/pages/user_list_page.dart';
  import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'core/firebase_messaging_service.dart';
  import 'injection_container.dart' as di;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void main() async {
    await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    await FirebaseMessagingService.initialize(
        onNotificationClick: (String? payload) {
          if (payload != null) {
            navigatorKey.currentState?.pushNamed(
              '/chat',
              arguments: {
                'userId': int.parse(payload),
                'selectedUser': int.parse(payload),
                'username': 'User $payload'
              },
            );
          }
        },
        onMessageOpenedApp: (RemoteMessage message) {
          final userId = int.tryParse(message.data['userId'] ?? '');
          final selectedUser = int.tryParse(message.data['selectedUser'] ?? '');
          final username = message.data['username'] ?? 'Unknown';

          if (userId != null && selectedUser != null) {
            navigatorKey.currentState?.pushNamed(
              '/chat',
              arguments: {
                'userId': userId,
                'selectedUser': selectedUser,
                'username': username
              },
            );
          }
        }
    );

    await di.init();
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => di.sl<AuthBloc>(),
            ),
            BlocProvider<ChatBloc>(
              create: (context) => di.sl<ChatBloc>(),
            ),
            BlocProvider<BlockeduserBloc>(
              create: (context) => di.sl<BlockeduserBloc>(),
            ),
            BlocProvider<StudentBloc>(
              create: (context) => di.sl<StudentBloc>()..add(GetStudentsEvent('duren')),
            ),
            BlocProvider<UserBloc>(create: (context) => di.sl<UserBloc>(),)
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/auth',
            routes: {
              '/auth': (context) => AuthGate(),
              '/login': (context) => LoginPage(),
              '/register': (context) => RegisterPage(),
              '/chat': (context) => ChatPage(),
              '/blocked': (context) => BlockedUsersPage(),
              '/users': (context) => UserListPage()
            },
          ));
    }
  }

  class Blank extends StatelessWidget {
    const Blank({super.key});

    @override
    Widget build(BuildContext context) {
      return const Placeholder();
    }
  }
