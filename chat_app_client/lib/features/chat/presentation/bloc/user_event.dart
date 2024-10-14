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
}

class ReportUserEvent extends UserEvent {
  final int reportUserId;
  final String reason;

  const ReportUserEvent({required this.reason, required this.reportUserId});

  @override
  List<Object> get props => [reason, reportUserId];
}