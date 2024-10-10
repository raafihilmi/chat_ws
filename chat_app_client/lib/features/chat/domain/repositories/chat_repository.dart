import 'package:chat_app_client/core/error/failures.dart';
import 'package:chat_app_client/features/chat/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Stream<Message> get messageStream;
  Future<Either<Failure, List<Message>>> getChatHistory(int userId);
  Future<Either<Failure, Message>> sendMessage(int receiverId, String message);
  void connect();
  void disconnect();
}