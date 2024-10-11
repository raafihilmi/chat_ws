import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/features/authentication/domain/usecases/login_usecase.dart';
import 'package:chat_app_client/features/authentication/domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthBloc({required this.loginUseCase, required this.registerUseCase})
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(
        LoginParams(username: event.username, password: event.password));
    result.fold(
      (failure) => emit(AuthError(message: 'Login failed $failure')),
      (token) => emit(AuthAuthenticated(token: token)),
    );
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(RegisterParams(
        username: event.username,
        password: event.password,
        email: event.email));
    result.fold(
        (failure) => emit(AuthError(message: 'Registration failed: $failure')),
        (_) => emit(AuthRegistered()));
  }
}
