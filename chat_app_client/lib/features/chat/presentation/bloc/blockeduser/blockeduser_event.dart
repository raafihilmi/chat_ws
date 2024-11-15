part of 'blockeduser_bloc.dart';

abstract class BlockeduserEvent extends Equatable {
  const BlockeduserEvent();

  @override
  List<Object> get props => [];
}

class GetBlockedUsersEvent extends BlockeduserEvent {

  const GetBlockedUsersEvent();

  @override
  List<Object> get props => [];
}

class UnblockUserEvent extends BlockeduserEvent {
  final int unblockedUserId;

  const UnblockUserEvent(this.unblockedUserId);

  @override
  List<Object> get props => [unblockedUserId];
}
