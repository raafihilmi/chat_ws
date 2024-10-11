import '../../../../core/api/api_consumer.dart';
import '../models/user_models.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getAvailableUsers();
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
}
