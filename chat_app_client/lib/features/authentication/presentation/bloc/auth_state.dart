part of 'auth_bloc.dart';


abstract class AuthState extends Equatable{
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;

  const AuthAuthenticated({required this.token});

  @override
  List<Object?> get props => [token];
}

class AuthRegistered extends AuthState {
  final String message;

  const AuthRegistered({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

