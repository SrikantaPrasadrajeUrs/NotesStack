
class UserModel{
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isBioMetricEnabled;
  final String profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.profileImageUrl,
    required this.isBioMetricEnabled,
  });

  @override
  String toString() {
    return "User => name: $name, email: $email";
  }
}