import '../../../../shared/models/project_model.dart';
import '../../../../shared/models/task_model.dart';

class ResDashboard {
  final List<ProjectModel> projects;
  final List<TaskModel> tasks;

  const ResDashboard({
    required this.projects,
    required this.tasks,
  });

  factory ResDashboard.fromJson(Map<String, dynamic> json) {
    return ResDashboard(
      projects: (json['projects'] as List)
          .map(
            (item) => ProjectModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
      tasks: (json['tasks'] as List)
          .map(
            (item) => TaskModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projects': projects.map((item) => item.toJson()).toList(),
      'tasks': tasks.map((item) => item.toJson()).toList(),
    };
  }
}