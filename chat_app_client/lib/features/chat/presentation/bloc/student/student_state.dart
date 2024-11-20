part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentConnected extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> message;

  const StudentLoaded(this.message);

  @override
  List<Object> get props => [message];
}

class MessageReceived extends StudentState {
  final Message message;

  const MessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class StudentError extends StudentState {
  final String message;

  const StudentError(this.message);

  @override
  List<Object> get props => [message];
}