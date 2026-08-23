class OrgModel {
  final String id;
  final String name;

  const OrgModel({
    required this.id,
    required this.name,
  });

  factory OrgModel.fromJson(Map<String, dynamic> json) {
    return OrgModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}