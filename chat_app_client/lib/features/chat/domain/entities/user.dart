import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String username;
  final String email;

  const User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.username,
    required this.email,
  });

  @override
  List<Object?> get props => [id, createdAt, updatedAt, deletedAt, username, email];
}