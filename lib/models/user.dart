class Users {
  final String id; 
  final String name;
  final String email;
  final String role;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'No email',
      role: json['role'] ?? 'No role',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
