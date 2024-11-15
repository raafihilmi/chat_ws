import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';
import 'block_user.dart';

class UnblockUser implements UseCase<void, BlockUserParams>{
  final UserRepository userRepository;

  UnblockUser(this.userRepository);

  @override
  Future<Either<Failure, void>> call(BlockUserParams params) {
    return userRepository.blockUser(params.blockedUserId);

  }
}