import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:chat_app_client/features/chat/domain/usecases/connect_chat_usecase.dart';
import 'package:dartz/dartz.dart';

class DisconnectChatUseCase implements UseCase<void, NoParams> {
  final ChatRepository chatRepository;

  DisconnectChatUseCase(this.chatRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      chatRepository.disconnect();
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure());
    }
  }


}