import 'package:chat_app_client/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/message.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Message> get messageStream => remoteDataSource.messageStream;

  @override
  Future<Either<Failure, List<Message>>> getChatHistory(int userId) async {
    try {
      final messages = await remoteDataSource.getChatHistory(userId);
      return Right(messages);
    }catch(e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(int receiverId, String message) async {
    try {
      final sentMessage = await remoteDataSource.sendMessage(receiverId, message);
      return Right(sentMessage);
    } catch(e) {
      return Left(ServerFailure());
    }
  }

  @override
  void connect() {
    remoteDataSource.connect();
  }

  @override
  void disconnect() {
    remoteDataSource.disconnect();
  }
}