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