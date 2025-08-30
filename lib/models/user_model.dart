
class UserModel{
  final String id;
  final String? name;
  final String? email;
  final String? password;
  final bool isBioMetricEnabled;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.password,
    this.profileImageUrl,
    this.isBioMetricEnabled = false,
  });

  UserModel copyWith({String? profileImage}){
    return UserModel(
      id: id,
      name: name,
      email: email,
      password: password,
      profileImageUrl: profileImage??profileImageUrl,
      isBioMetricEnabled: isBioMetricEnabled,
    );
  }

  @override
  String toString() {
    return "User => id: $id name: $name, email: $email, isBiometricEnabled: $isBioMetricEnabled";
  }
}