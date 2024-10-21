import 'package:chat_app_client/features/chat/data/models/user_models.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getAvailableUsers();
  Future<Either<Failure, void>> blockUser( int blockedUserId);
  Future<Either<Failure, void>> reportUser(String reason, int reportedUserId);
  Future<Either<Failure, List<UserModel>>> getBlockedUsers();
}