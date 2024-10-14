import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getAvailableUsers();
  Future<Either<Failure, void>> blockUser( int blockedUserId);
  Future<Either<Failure, void>> reportUser(String reason, int reportedUserId);
}