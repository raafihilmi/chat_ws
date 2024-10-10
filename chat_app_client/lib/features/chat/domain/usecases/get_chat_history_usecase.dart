import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class GetChatHistoryUseCase implements UseCase<List<Message>, int> {
  final ChatRepository repository;

  GetChatHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(int userId) async {
    return await repository.getChatHistory(userId);
  }
}