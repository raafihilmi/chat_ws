import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<User>>> getAvailableUsers() async {
    try {
      final remoteUsers = await remoteDataSource.getAvailableUsers();
      return Right(remoteUsers);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
