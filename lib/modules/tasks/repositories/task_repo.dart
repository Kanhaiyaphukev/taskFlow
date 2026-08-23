import '../../projects/models/response/res_project.dart';
import '../models/request/req_create_task.dart';
import '../models/request/req_update_task.dart';
import '../models/request/res_assign_task.dart';
import '../models/response/res_task.dart';
import '../models/response/res_task_user.dart';

abstract class TaskRepository {
  // Get all tasks.
  Future<List<ResTask>> getTasks({
    String? projectId,
  });

  // Get all projects for task creation.
  Future<List<ResProject>> getProjects();

  // Get organization users for task assignment.
  Future<List<ResTaskUser>> getUsers();

  // Get task by ID.
  Future<ResTask> getTaskById(
      String taskId,
      );

  // Create task.
  Future<ResTask> createTask(
      ReqCreateTask request,
      );

  // Update task.
  Future<ResTask> updateTask(
      String taskId,
      ReqUpdateTask request,
      );

  // Delete task.
  Future<void> deleteTask(
      String taskId,
      );

  // Update task status.
  Future<ResTask> updateTaskStatus(
      String taskId,
      String status,
      );

  // Update task priority.
  Future<ResTask> updateTaskPriority(
      String taskId,
      String priority,
      );

  // Assign task.
  Future<ResTask> assignTask(
      String taskId,
      ReqAssignTask request,
      );
}