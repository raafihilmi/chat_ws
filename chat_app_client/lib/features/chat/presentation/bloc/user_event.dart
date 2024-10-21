part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetAvailableUsersEvent extends UserEvent {

  const GetAvailableUsersEvent();

  @override
  List<Object> get props => [];
}

class BlockUserEvent extends UserEvent {
  final int blockedUserId;

  const BlockUserEvent(this.blockedUserId);

  @override
  List<Object> get props => [blockedUserId];

}class GetBlockedUsersEvent extends UserEvent {

  const GetBlockedUsersEvent();

  @override
  List<Object> get props => [];
}

class UnblockUserEvent extends UserEvent {
  final int unblockedUserId;

  const UnblockUserEvent(this.unblockedUserId);

  @override
  List<Object> get props => [unblockedUserId];
}

class ReportUserEvent extends UserEvent {
  final int reportUserId;
  final String reason;

  const ReportUserEvent({required this.reason, required this.reportUserId});

  @override
  List<Object> get props => [reason, reportUserId];
}