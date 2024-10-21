import 'package:chat_app_client/features/chat/domain/usecases/block_user.dart';
import 'package:chat_app_client/features/chat/domain/usecases/get_blocked_users.dart';
import 'package:chat_app_client/features/chat/domain/usecases/report_user.dart';
import 'package:chat_app_client/features/chat/domain/usecases/unblock-user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_available_users.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetAvailableUsers getAvailableUsers;
  final GetBlockedUsers getBlockedUsers;
  final BlockUser blockUser;
  final UnblockUser unblockUser;
  final ReportUser reportUser;

  UserBloc(
      {required this.getAvailableUsers,
      required this.getBlockedUsers,
      required this.blockUser,
      required this.unblockUser,
      required this.reportUser})
      : super(UserInitial()) {
    on<GetAvailableUsersEvent>(_onGetAvailableUsersEvent);
    on<GetBlockedUsersEvent>(_onGetBlockedUsersEvent);
    on<BlockUserEvent>(_onBlockUserEvent);
    on<UnblockUserEvent>(_onUnblockUserEvent);
    on<ReportUserEvent>(_onReportUserEvent);
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

  Future<void> _onGetBlockedUsersEvent(
      GetBlockedUsersEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await getBlockedUsers(NoParams());
    result.fold(
      (failure) =>
          emit(UserError(message: 'Failed to load blocked users: $failure')),
      (users) => emit(UserLoaded(users: users)),
    );
  }

  Future<void> _onBlockUserEvent(
      BlockUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result =
        await blockUser(BlockUserParams(blockedUserId: event.blockedUserId));
    result.fold(
      (failure) => emit(UserError(message: 'Failed to block user: $failure')),
      (block) =>
          emit(const UserActionSuccess(message: 'User blocked successfully')),
    );
  }

  Future<void> _onUnblockUserEvent(
      UnblockUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await unblockUser(
        BlockUserParams(blockedUserId: event.unblockedUserId));
    result.fold(
      (failure) => emit(UserError(message: 'Failed to unblock user: $failure')),
      (block) =>
          emit(const UserActionSuccess(message: 'User unblocked successfully')),
    );
  }

  Future<void> _onReportUserEvent(
      ReportUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await reportUser(ReportUserParams(
        reason: event.reason, reportedUserId: event.reportUserId));
    result.fold(
        (failure) =>
            emit(UserError(message: 'Failed to report user: $failure')),
        (report) => emit(const UserActionSuccess(message: 'User reported')));
  }
}
