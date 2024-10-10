import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class SendMessageUseCase implements UseCase<void, SendMessageParams>{
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.receiverId, params.message);
  }
}
class SendMessageParams {
  final int receiverId;
  final String message;

  SendMessageParams({required this.receiverId, required this.message});
}