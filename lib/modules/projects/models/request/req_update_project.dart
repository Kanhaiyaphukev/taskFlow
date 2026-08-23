class ReqUpdateProject {
  final String name;
  final String description;

  const ReqUpdateProject({
    required this.name,
    required this.description,
  });

  factory ReqUpdateProject.fromJson(Map<String, dynamic> json) {
    return ReqUpdateProject(
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}