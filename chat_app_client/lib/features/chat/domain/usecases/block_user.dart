import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/user_repository.dart';

class BlockUser implements UseCase<void, BlockUserParams>{
  final UserRepository userRepository;

  BlockUser(this.userRepository);

  @override
  Future<Either<Failure, void>> call(BlockUserParams params) {
    return userRepository.blockUser(params.blockedUserId);

  }
}

class BlockUserParams {
  final int blockedUserId;

  BlockUserParams({required this.blockedUserId});
}