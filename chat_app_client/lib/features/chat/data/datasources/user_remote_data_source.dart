import '../../../../core/api/api_consumer.dart';
import '../models/user_models.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getAvailableUsers();
  Future<void> blockUser(int blockedUserId);
  Future<void> reportUser(String reason,int reportUserId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiConsumer apiConsumer;

  UserRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<List<UserModel>> getAvailableUsers() async {
    final response = await apiConsumer.getAvailableUsers();
    return response.map((data) =>
        UserModel(id: data.id,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
            username: data.username,
            email: data.email)).toList();
    }

  @override
  Future<void> blockUser(int blockedUserId) async {
    await apiConsumer.blockUser(blockedUserId);
  }

  @override
  Future<void> reportUser(String reason, int reportUserId) async {
    await apiConsumer.reportUser(reason, reportUserId);
  }

}
