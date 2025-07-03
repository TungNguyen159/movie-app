class Users {
  final String id;
  final String name;
  final String? email;
  final int? age;
  final String? imageuser;
  final String? role;
  final String? status;

  Users({
    required this.id,
    required this.name,
    this.email,
    this.age,
    this.imageuser,
    this.role,
    this.status,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? 'No email',
      age: json['age'] ?? 0,
      imageuser: json['image_user'] ?? '',
      role: json['role'] ?? 'No role',
      status: json["status"] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'image_user': imageuser,
      'role': role,
      'status': status,
    };
  }
}
