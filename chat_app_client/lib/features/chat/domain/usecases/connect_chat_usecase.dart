import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ConnectChatUseCase implements UseCase<void, NoParams> {
  final ChatRepository repository;

  ConnectChatUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
   return await repository.connect();
  }

}

class NoParams {
}