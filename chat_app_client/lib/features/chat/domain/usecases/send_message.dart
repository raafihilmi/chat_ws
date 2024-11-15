import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, void>> execute(Message message) {
    return repository.sendMessage(message);
  }
}