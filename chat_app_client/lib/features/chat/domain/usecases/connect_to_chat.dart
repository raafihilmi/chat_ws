import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class ConnectToChat {
  final ChatRepository repository;

  ConnectToChat(this.repository);

  Stream<Message> execute(int currentUserId, int otherUserId) {
    return repository.connectToChat(currentUserId, otherUserId);
  }
}