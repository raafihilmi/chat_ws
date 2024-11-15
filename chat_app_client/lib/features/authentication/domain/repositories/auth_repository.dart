import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String username, password);
  Future<Either<Failure, void>> register(String username, password, email);
}