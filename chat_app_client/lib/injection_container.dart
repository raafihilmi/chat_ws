import 'package:chat_app_client/core/api/api_consumer.dart';
import 'package:chat_app_client/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:chat_app_client/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:chat_app_client/features/authentication/domain/repositories/auth_repository.dart';
import 'package:chat_app_client/features/authentication/domain/usecases/login_usecase.dart';
import 'package:chat_app_client/features/authentication/domain/usecases/register_usecase.dart';
import 'package:chat_app_client/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:chat_app_client/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:chat_app_client/features/chat/data/datasources/chat_websocket_service.dart';
import 'package:chat_app_client/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app_client/features/chat/domain/repositories/chat_repository.dart';
import 'package:chat_app_client/features/chat/domain/usecases/block_user.dart';
import 'package:chat_app_client/features/chat/domain/usecases/get_blocked_users.dart';
import 'package:chat_app_client/features/chat/domain/usecases/report_user.dart';
import 'package:chat_app_client/features/chat/domain/usecases/unblock_user.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/blockeduser/blockeduser_bloc.dart';
import 'package:chat_app_client/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/chat/data/datasources/user_remote_data_source.dart';
import 'features/chat/data/repositories/user_repository_impl.dart';
import 'features/chat/domain/repositories/user_repository.dart';
import 'features/chat/domain/usecases/connect_to_chat.dart';
import 'features/chat/domain/usecases/get_available_users.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/user/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // core
  sl.registerLazySingleton(
    () => ApiConsumer(),
  );

  // feature = auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerFactory(
    () => AuthBloc(loginUseCase: sl(), registerUseCase: sl()),
  );

  // feature - chat
  sl.registerLazySingleton(() => ChatWebsocketService());
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerFactory(
    () => ChatBloc(sl(), sl()),
  );

  // feature - user list
  sl.registerLazySingleton(() => GetAvailableUsers(sl()));
  sl.registerLazySingleton(() => GetBlockedUsers(sl()));
  sl.registerLazySingleton(()=> BlockUser(sl()));
  sl.registerLazySingleton(()=> UnblockUser(sl()));
  sl.registerLazySingleton(()=> ReportUser(sl()));
  sl.registerLazySingleton(() => ConnectToChat(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl()));
  sl.registerFactory(() => UserBloc(getAvailableUsers: sl(),blockUser: sl(), reportUser: sl()));
  sl.registerFactory(() => BlockeduserBloc(unblockUser: sl(), getBlockedUsers: sl()));
}
