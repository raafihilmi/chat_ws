import 'package:chat_app_client/core/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/my_textfield.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  RegisterPage({super.key});

  void register(BuildContext context) {
    if (_passwordController.text == _confirmPasswordController.text) {
      // Dispatch RegisterRequested event
      BlocProvider.of<AuthBloc>(context).add(
        RegisterRequested(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) =>
          const AlertDialog(title: Text("Passwords don't match!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                const SizedBox(height: 40,),
                Icon(Icons.message,
                    size: 60, color: Theme
                        .of(context)
                        .colorScheme
                        .primary),
                const SizedBox(
                  height: 20,
                ),
                //welcome message
                Text("Lets create an account for you",
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        fontSize: 16)),
          
                const SizedBox(
                  height: 25,
                ),
          
                //email textfield
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: _usernameController,
                ),
          
                const SizedBox(
                  height: 25,
                ),
          
                //email textfield
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),
          
                const SizedBox(
                  height: 16,
                ),
          
                //password textfield
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 16,
                ),
          
                //password textfield
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(
                  height: 25,
                ),
                //login btn
                MyButton(
                  text: "Register",
                  onTap: () => register(context), colorText: Colors.white, colorBg: Colors.blueAccent,
                ),
          
                const SizedBox(
                  height: 25,
                ),
          
                //register btn
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary)),
                    GestureDetector(
                      onTap: () => Navigator.pop,
                      child: const Text(
                        "Login now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}