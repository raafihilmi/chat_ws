import 'package:chat_app_client/core/components/my_button.dart';
import 'package:chat_app_client/core/components/my_textfield.dart';
import 'package:chat_app_client/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed('/users');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Masuk",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87),
              ),
              const Text(
                "Silahkan masuk menggunakan email dan kata sandi yang terdaftar",
                style: TextStyle(color: Colors.blueGrey,),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                  hintText: 'Username',
                  obscureText: false,
                  controller: _usernameController),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  hintText: 'Password',
                  obscureText: true,
                  controller: _passwordController),
              const SizedBox(
                height: 36,
              ),
              MyButton(
                  text: "Login",
                  onTap: () {
                    context.read<AuthBloc>().add(LoginRequested(
                        username: _usernameController.text,
                        password: _passwordController.text));
                  },
                  colorText: Colors.white,
                  colorBg: Colors.blueAccent),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                  text: "Register",
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  colorText: Colors.black45,
                  colorBg: Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}
