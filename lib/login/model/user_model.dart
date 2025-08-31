class UserModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? token;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String? token) {
    final user = json['user'];
    return UserModel(
      id: user['_id'] ,
      firstName: user['first_name']??'N/A',
      lastName: user['last_name']??'N/A',
      email: user['email']??'N/A',
      mobile: user['mobile'] ?? 'N/A',
      token: token ?? 'N/A',
    );
  }
}
