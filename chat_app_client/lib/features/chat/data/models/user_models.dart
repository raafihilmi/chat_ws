import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int id,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    required String username,
    required String email,
  }) : super(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    username: username,
    email: email,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt: json['DeletedAt'] != null ? DateTime.parse(json['DeletedAt']) : null,
      username: json['username'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'DeletedAt': deletedAt,
      'username': username,
      'email': email,
    };
  }
}