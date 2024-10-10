abstract class AuthRemoteDataSource {
  Future<String> login(String username, password);
  Future<void> register(String username, password, email);
}