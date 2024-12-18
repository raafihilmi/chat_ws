import 'package:chat_app_client/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Stream<List<ChatMessage>> getChatMessages(String receiverId);
  Future<void> sendMessage(String receiverId, String message);
  Future<void> markMessageAsSeen(String messageId);
  Future<void> setTypingStatus(String receiverId, bool isTyping);
}
