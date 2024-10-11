import 'dart:developer';

import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

class GetAvailableUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;

  GetAvailableUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getAvailableUsers();
  }
}

class NoParams {}
