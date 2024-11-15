part of 'blockeduser_bloc.dart';

abstract class BlockeduserState extends Equatable {
  const BlockeduserState();

  @override
  List<Object> get props => [];
}

class BlockInitial extends BlockeduserState {}

class BlockLoading extends BlockeduserState {}

class BlockLoaded extends BlockeduserState {
  final List<User> users;

  const BlockLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class BlockError extends BlockeduserState {
  final String message;

  const BlockError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserActionSuccess extends BlockeduserState {
  final String message;

  const UserActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}