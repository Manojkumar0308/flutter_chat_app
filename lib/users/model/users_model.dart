class Users {
  final String id;
  final String? name;
  final String? email;

  Users({
    required this.id,
    this.name,
    this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['_id'],
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
    );
  }
}
