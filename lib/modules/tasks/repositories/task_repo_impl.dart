import '../../../data/dataSources/mock_data_source.dart';
import '../../projects/models/response/res_project.dart';
import '../models/request/req_create_task.dart';
import '../models/request/req_update_task.dart';
import '../models/request/res_assign_task.dart';
import '../models/response/res_task.dart';
import '../models/response/res_task_user.dart';
import 'task_repo.dart';

class TaskRepositoryImpl implements TaskRepository {
  final MockDataSource dataSource;

  TaskRepositoryImpl({
    required this.dataSource,
  });

  // Get all tasks.
  @override
  Future<List<ResTask>> getTasks({
    String? projectId,
  }) {
    return dataSource.getTasks(
      projectId: projectId,
    );
  }

  // Get all projects.
  @override
  Future<List<ResProject>> getProjects() {
    return dataSource.getProjects();
  }

  // Get organization users.
  @override
  Future<List<ResTaskUser>> getUsers() {
    return dataSource.getUsers();
  }

  // Get task by ID.
  @override
  Future<ResTask> getTaskById(
      String taskId,
      ) {
    return dataSource.getTaskById(
      taskId,
    );
  }

  // Create task.
  @override
  Future<ResTask> createTask(
      ReqCreateTask request,
      ) {
    return dataSource.createTask(
      request: request,
    );
  }

  // Update task.
  @override
  Future<ResTask> updateTask(
      String taskId,
      ReqUpdateTask request,
      ) {
    return dataSource.updateTask(
      taskId: taskId,
      request: request,
    );
  }

  // Delete task.
  @override
  Future<void> deleteTask(
      String taskId,
      ) {
    return dataSource.deleteTask(
      taskId: taskId,
    );
  }

  // Update task status.
  @override
  Future<ResTask> updateTaskStatus(
      String taskId,
      String status,
      ) {
    return dataSource.updateTaskStatus(
      taskId: taskId,
      status: status,
    );
  }

  // Update task priority.
  @override
  Future<ResTask> updateTaskPriority(
      String taskId,
      String priority,
      ) {
    return dataSource.updateTaskPriority(
      taskId: taskId,
      priority: priority,
    );
  }

  // Assign task.
  @override
  Future<ResTask> assignTask(
      String taskId,
      ReqAssignTask request,
      ) {
    return dataSource.assignTask(
      taskId: taskId,
      request: request,
    );
  }
}