class ResTaskUser {
  final String id;
  final String name;
  final String email;

  const ResTaskUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ResTaskUser.fromJson(Map<String, dynamic> json) {
    return ResTaskUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}