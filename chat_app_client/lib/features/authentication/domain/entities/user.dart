import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String password;

  const User(
      {required this.id, required this.username, required this.password});

  @override
  List<Object> get props => [id, username, password];
}
