part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class GetStudentsEvent extends StudentEvent {
  final String search;

  const GetStudentsEvent(this.search);

  @override
  List<Object> get props => [search];
}
class SearchStudentsEvent extends StudentEvent {
  final String search;

  const SearchStudentsEvent(this.search);

  @override
  List<Object> get props => [search];
}