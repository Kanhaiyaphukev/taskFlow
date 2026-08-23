class ReqCreateProject {
  final String name;
  final String description;

  const ReqCreateProject({
    required this.name,
    required this.description,
  });

  factory ReqCreateProject.fromJson(Map<String, dynamic> json) {
    return ReqCreateProject(
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