import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Stream<Message> connectToChat(int currentUserId, int otherUserId);
  Future<Either<Failure, void>> sendMessage(Message message);
}