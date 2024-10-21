import 'package:bloc/bloc.dart';
import 'package:chat_app_client/features/chat/domain/usecases/get_blocked_users.dart';
import 'package:chat_app_client/features/chat/domain/usecases/unblock_user.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/block_user.dart';
import '../../../domain/usecases/get_available_users.dart';

part 'blockeduser_event.dart';
part 'blockeduser_state.dart';

class BlockeduserBloc extends Bloc<BlockeduserEvent, BlockeduserState> {
  final GetBlockedUsers getBlockedUsers;
  final UnblockUser unblockUser;

  BlockeduserBloc({required this.getBlockedUsers, required this.unblockUser}) : super(BlockInitial()) {
    on<GetBlockedUsersEvent>(_onGetBlockedUsersEvent);
    on<UnblockUserEvent>(_onUnblockUserEvent);
  }

  Future<void> _onGetBlockedUsersEvent(
      GetBlockedUsersEvent event, Emitter<BlockeduserState> emit) async {
    emit(BlockLoading());

    final result = await getBlockedUsers(NoParams());
    result.fold(
          (failure) =>
          emit(BlockError(message: 'Failed to load blocked users: $failure')),
          (users) => emit(BlockLoaded(users: users)),
    );
  }

  Future<void> _onUnblockUserEvent(
      UnblockUserEvent event, Emitter<BlockeduserState> emit) async {
    emit(BlockLoading());
    final result = await unblockUser(
        BlockUserParams(blockedUserId: event.unblockedUserId));
    result.fold(
          (failure) => emit(BlockError(message: 'Failed to unblock user: $failure')),
          (block) =>
          emit(const UserActionSuccess(message: 'User unblocked successfully')),
    );
  }
}
