import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/dialogs.dart';
import '../../../shared/widgets/regx_validator.dart';
import '../../projects/models/response/res_project.dart';
import '../models/request/req_create_task.dart';
import '../models/request/req_update_task.dart';
import '../models/request/res_assign_task.dart';
import '../models/response/res_task.dart';
import '../models/response/res_task_user.dart';
import '../repositories/task_repo.dart';

class TaskController extends GetxController {
  final TaskRepository repository;
  TaskController({required this.repository});
  final isLoading = false.obs;
  final isDataLoaded = false.obs;
  final isDetailsLoading = false.obs;
  final isFormLoading = false.obs;
  final isOrgAdmin = false.obs;
  final tasks = <ResTask>[].obs;
  final filteredTasks = <ResTask>[].obs;
  final users = <ResTaskUser>[].obs;
  final projects = <ResProject>[].obs;
  final selectedTask = Rxn<ResTask>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  final selectedProjectId = ''.obs;
  final selectedProjectName = ''.obs;
  final selectedStatus = 'todo'.obs;
  final selectedPriority = 'medium'.obs;
  final selectedAssigneeId = Rxn<String>();
  final selectedAssigneeName = ''.obs;
  final filterStatus = Rxn<String>();
  final filterPriority = Rxn<String>();
  final filterAssignee = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    checkAdmin();
    loadProjects();
    loadUsers();
    getTasks();

    final taskId = Get.arguments;
    if (taskId is String) {
      loadTaskDetails(taskId);
    }
  }

  /// Check whether current user is organization admin.
  Future<void> checkAdmin() async {
    final storage = FlutterStorage();
    final keys = FlutterStorageKeys();

    final role = await storage.readStorage(keys.role);

    debugPrint('ADMIN CHECK: stored role = $role');

    isOrgAdmin.value = role.toString().trim().toLowerCase() == 'org_admin';

    debugPrint('ADMIN CHECK: isOrgAdmin = ${isOrgAdmin.value}');
  }

  /// Get all projects for task creation.
  Future<void> loadProjects() async {
    try {
      final response = await repository.getProjects();

      projects.assignAll(response);
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Get all tasks
  Future<void> getTasks() async {
    try {
      isLoading.value = true;

      final response = await repository.getTasks();

      tasks.assignAll(response);
      applyFilters();
      isDataLoaded.value = true;
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh the task list
  Future<void> refreshTasks() async {
    try {
      final response = await repository.getTasks();

      tasks.assignAll(response);
      applyFilters();
      isDataLoaded.value = true;
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Get organization users for task assignment
  Future<void> loadUsers() async {
    try {
      final response = await repository.getUsers();

      users.assignAll(response);
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Get task details by ID
  Future<void> loadTaskDetails(String taskId) async {
    try {
      isDetailsLoading.value = true;
      selectedTask.value = null;

      final response = await repository.getTaskById(taskId);

      selectedTask.value = response;
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isDetailsLoading.value = false;
    }
  }

  /// Apply selected task filters
  void applyFilters() {
    var result = List<ResTask>.from(tasks);

    if (filterStatus.value != null) {
      result = result
          .where((task) => task.status == filterStatus.value)
          .toList();
    }

    if (filterPriority.value != null) {
      result = result
          .where((task) => task.priority == filterPriority.value)
          .toList();
    }

    if (filterAssignee.value != null) {
      result = result
          .where((task) => task.assigneeId == filterAssignee.value)
          .toList();
    }

    filteredTasks.assignAll(result);
  }

  /// Set status filter
  void setStatusFilter(String? value) {
    filterStatus.value = value;
    applyFilters();
  }

  /// Set priority filter
  void setPriorityFilter(String? value) {
    filterPriority.value = value;
    applyFilters();
  }

  /// Set assignee filter
  void setAssigneeFilter(String? value) {
    filterAssignee.value = value;
    applyFilters();
  }

  /// Clear all task filters
  void clearFilters() {
    filterStatus.value = null;
    filterPriority.value = null;
    filterAssignee.value = null;

    applyFilters();
  }

  /// Prepare fields for task creation
  void prepareCreateTask() {
    clearForm();
  }

  /// Create a new task
  Future<void> createTask() async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to create tasks');
      return;
    }

    if (selectedProjectId.value.trim().isEmpty) {
      AppToast.errorToast('Project is required');
      return;
    }

    final titleError = RegexValidator.validateTaskTitle(titleController.text);

    if (titleError != null) {
      AppToast.errorToast(titleError);
      return;
    }

    final descriptionError = RegexValidator.validateTaskDescription(
      descriptionController.text,
    );

    if (descriptionError != null) {
      AppToast.errorToast(descriptionError);
      return;
    }

    if (dueDateController.text.trim().isEmpty) {
      AppToast.errorToast('Due date is required');
      return;
    }

    try {
      isFormLoading.value = true;

      final request = ReqCreateTask(
        projectId: selectedProjectId.value,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus.value,
        priority: selectedPriority.value,
        assigneeId: selectedAssigneeId.value,
        dueDate: dueDateController.text.trim(),
      );

      final createdTask = await repository.createTask(request);

      tasks.add(createdTask);
      applyFilters();

      clearForm();

      isFormLoading.value = false;

      Get.close(1);

      AppToast.successToast('Task created successfully');
    } catch (e) {
      isFormLoading.value = false;

      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Update an existing task
  Future<void> updateTask(String taskId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to update tasks');
      return;
    }

    final titleError = RegexValidator.validateTaskTitle(titleController.text);

    if (titleError != null) {
      AppToast.errorToast(titleError);
      return;
    }

    final descriptionError = RegexValidator.validateTaskDescription(
      descriptionController.text,
    );

    if (descriptionError != null) {
      AppToast.errorToast(descriptionError);
      return;
    }

    if (dueDateController.text.trim().isEmpty) {
      AppToast.errorToast('Due date is required');
      return;
    }

    try {
      isFormLoading.value = true;

      final request = ReqUpdateTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        status: selectedStatus.value,
        priority: selectedPriority.value,
        assigneeId: selectedAssigneeId.value,
        dueDate: dueDateController.text.trim(),
      );

      final updatedTask = await repository.updateTask(taskId, request);

      _replaceTask(updatedTask);

      clearForm();

      isFormLoading.value = false;

      Get.close(1);

      AppToast.successToast('Task updated successfully');
    } catch (e) {
      isFormLoading.value = false;

      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Update task status
  Future<void> updateStatus(String taskId, String status) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to update task status');
      return;
    }

    try {
      final updatedTask = await repository.updateTaskStatus(taskId, status);

      _replaceTask(updatedTask);

      AppToast.successToast('Task status updated');
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Update task priority
  Future<void> updatePriority(String taskId, String priority) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to update task priority');
      return;
    }

    try {
      final updatedTask = await repository.updateTaskPriority(taskId, priority);

      _replaceTask(updatedTask);

      AppToast.successToast('Task priority updated');
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Assign or unassign a task
  Future<void> assignTask(String taskId, String? userId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to assign tasks');
      return;
    }

    try {
      if (userId != null && !users.any((user) => user.id == userId)) {
        AppToast.errorToast('User does not belong to the organization');
        return;
      }

      final updatedTask = await repository.assignTask(
        taskId,
        ReqAssignTask(assigneeId: userId),
      );

      _replaceTask(updatedTask);

      AppToast.successToast(
        userId == null ? 'Task unassigned' : 'Task assigned successfully',
      );
    } catch (e) {
      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Show task deletion confirmation
  Future<void> confirmDeleteTask(String taskId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to delete tasks');
      return;
    }

    await Dialogs().deleteConfirm(
      title: 'Delete Task!',
      message: 'Are you sure you want to delete this task?',
      onDelete: () async {
        Get.back();
        await deleteTask(taskId);
      },
    );
  }

  /// Delete an existing task
  Future<void> deleteTask(String taskId) async {
    if (!isOrgAdmin.value) {
      AppToast.errorToast('You are not authorized to delete tasks');
      return;
    }

    try {
      isDetailsLoading.value = true;

      await repository.deleteTask(taskId);

      tasks.removeWhere((task) => task.id == taskId);

      filteredTasks.removeWhere((task) => task.id == taskId);

      if (selectedTask.value?.id == taskId) {
        selectedTask.value = null;
      }

      isDetailsLoading.value = false;

      Get.back();

      AppToast.successToast('Task deleted successfully');
    } catch (e) {
      isDetailsLoading.value = false;

      AppToast.errorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Prepare fields for task editing
  void prepareEditTask(ResTask task) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    dueDateController.text = task.dueDate;

    selectedProjectId.value = task.projectId;

    final project = projects.firstWhereOrNull(
          (project) => project.id == task.projectId,
    );

    selectedProjectName.value = project?.name ?? '';

    selectedStatus.value = task.status;
    selectedPriority.value = task.priority;

    selectedAssigneeId.value = task.assigneeId;
    selectedAssigneeName.value = getAssigneeName(task.assigneeId) ?? '';
  }

  /// Replace an updated task in local lists
  void _replaceTask(ResTask updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index != -1) {
      tasks[index] = updatedTask;
    }

    if (selectedTask.value?.id == updatedTask.id) {
      selectedTask.value = updatedTask;
    }

    applyFilters();
  }

  /// Clear task form fields
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
    selectedProjectId.value = '';
    selectedProjectName.value = '';
    selectedStatus.value = 'todo';
    selectedPriority.value = 'medium';
    selectedAssigneeId.value = null;
    selectedAssigneeName.value = '';
  }

  // Get assigned user's name.
  String? getAssigneeName(String? userId) {
    if (userId == null) {
      return null;
    }

    final user = users.firstWhereOrNull((user) => user.id == userId);

    return user?.name;
  }

  /// Dispose
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();

    super.onClose();
  }
}
