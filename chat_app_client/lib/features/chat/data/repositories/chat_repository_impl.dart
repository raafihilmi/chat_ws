import 'dart:developer';

import 'package:chat_app_client/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/message.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Message> connectToChat(int currentUserId, int otherUserId) {
    return remoteDataSource.connectToChat(currentUserId, otherUserId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      await remoteDataSource.sendMessage(message);
      return Right(null);
    } catch(e) {
      log(e.toString());
      return Left(ServerFailure());
    }
  }


}