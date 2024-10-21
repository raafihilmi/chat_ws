import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/data/models/user_models.dart';
import 'package:chat_app_client/features/chat/domain/repositories/user_repository.dart';
import 'package:chat_app_client/features/chat/domain/usecases/get_available_users.dart';
import 'package:dartz/dartz.dart';

class GetBlockedUsers implements UseCase<List<UserModel>, NoParams> {
  final UserRepository userRepository;

  GetBlockedUsers(this.userRepository);

  @override
  Future<Either<Failure, List<UserModel>>> call(NoParams params)async {
    return await userRepository.getBlockedUsers();
  }


}