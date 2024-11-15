import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/usecases/usecase.dart';

class LoginUseCase implements UseCase<String, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LoginParams {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});
}
