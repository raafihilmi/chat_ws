part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String password;
  final String email;

  const RegisterRequested({required this.username, required this.password, required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [username, password, email];
}
