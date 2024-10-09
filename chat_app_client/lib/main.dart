import 'package:chat_app_client/pages/login_page.dart';
import 'package:chat_app_client/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(onTap: () {

      },),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
