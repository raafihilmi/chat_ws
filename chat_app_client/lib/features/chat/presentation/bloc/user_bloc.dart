import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_available_users.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAvailableUsers getAvailableUsers;

  UserBloc({required this.getAvailableUsers}) : super(UserInitial()) {
    on<GetAvailableUsersEvent>(_onGetAvailableUsersEvent);
  }

  Future<void> _onGetAvailableUsersEvent(
      GetAvailableUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await getAvailableUsers(NoParams());
    result.fold(
      (failure) =>
          emit(UserError(message: 'Failed to load available users: $failure')),
      (users) => emit(UserLoaded(users: users)),
    );
  }
}
