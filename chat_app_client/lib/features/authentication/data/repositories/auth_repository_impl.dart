import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:chat_app_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> login(String username, password) async {
    try {
      final token = await remoteDataSource.login(username, password);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> register(
      String username, password, email) async {
    try {
      await remoteDataSource.register(username, password, email);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
