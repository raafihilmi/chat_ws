class UserModel {
  String? username;
  String password;
  String email;

  UserModel({
    this.username,
    required this.password,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    password: json["password"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "email": email,
  };
}
