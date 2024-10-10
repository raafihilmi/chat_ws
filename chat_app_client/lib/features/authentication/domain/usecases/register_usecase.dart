import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase implements UseCase<void, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    return await repository.register(params.username, params.password, params.email);
  }
}

class RegisterParams {
  final String username;
  final String password;
  final String email;

  RegisterParams({required this.username, required this.password, required this.email});
}