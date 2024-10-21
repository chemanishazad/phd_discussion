class UserModel {
  final String userId;
  final String name;
  final String email;
  final String username;
  final String authToken;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.username,
    required this.authToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      authToken: json['authToken'],
    );
  }
}
