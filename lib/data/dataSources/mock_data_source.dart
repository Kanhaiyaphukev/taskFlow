import 'dart:convert';
import 'package:flutter/services.dart';
import '../../modules/auth/models/request/req_login.dart';
import '../../modules/auth/models/response/response_login.dart';
import '../../modules/dashboard/models/response/res_dashboard.dart';
import '../../modules/profile/models/response/res_profile.dart';
import '../../modules/projects/models/request/req_create_project.dart';
import '../../modules/projects/models/request/req_update_project.dart';
import '../../modules/projects/models/response/res_project.dart';
import '../../modules/tasks/models/request/req_create_task.dart';
import '../../modules/tasks/models/request/req_update_task.dart';
import '../../modules/tasks/models/request/res_assign_task.dart';
import '../../modules/tasks/models/response/res_task.dart';
import '../../modules/tasks/models/response/res_task_user.dart';
import '../../shared/models/org_member_model.dart';
import '../../shared/models/org_model.dart';
import '../../shared/models/project_model.dart';
import '../../shared/models/task_model.dart';
import '../../shared/models/user_model.dart';

final class MockDataSource {
  List<Map<String, dynamic>>? _projects;
  List<Map<String, dynamic>>? _tasks;

  /// Simulation controls for assignment/demo purposes.
  bool simulateError = false;
  bool simulateOffline = false;
  Duration responseDelay = Duration.zero;

  /// Enable or update mock API simulation.
  void setSimulation({
    bool? error,
    bool? offline,
    Duration? delay,
  }) {
    if (error != null) {
      simulateError = error;
    }

    if (offline != null) {
      simulateOffline = offline;
    }

    if (delay != null) {
      responseDelay = delay;
    }
  }

  /// Reset all simulation states.
  void resetSimulation() {
    simulateError = false;
    simulateOffline = false;
    responseDelay = Duration.zero;
  }

  /// Simulate a request.When [allowCachedData] is true, previously loaded cached data, remains available while offline.
  Future<void> _simulateRequest({
    bool allowCachedData = false,
  }) async {
    if (responseDelay > Duration.zero) {
      await Future.delayed(responseDelay);
    }

    if (simulateError) {
      throw Exception('Simulated server error');
    }

    if (simulateOffline && !allowCachedData) {
      throw Exception(
        'You are offline. Please retry when connection is restored.',
      );
    }
  }

  /// Load mock JSON data from assets.
  Future<Map<String, dynamic>> _loadData() async {
    final jsonString = await rootBundle.loadString(
      'assets/mock_data/mock-data.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Login using mock credentials.
  Future<ResLogin> login(ReqLogin request) async {
    await _simulateRequest();

    final data = await _loadData();

    final authMock = data['auth_mock'] as Map<String, dynamic>;

    final credentials = List<Map<String, dynamic>>.from(
      authMock['test_credentials'],
    );

    final credential = credentials.firstWhere(
          (item) =>
      item['email'] == request.email.trim() &&
          item['password'] == request.password,
      orElse: () => throw Exception('Invalid email or password'),
    );

    final orgId = credential['org_id'] as String;

    final userJson = List<Map<String, dynamic>>.from(
      data['users'],
    ).firstWhere(
          (item) => item['email'] == request.email.trim(),
      orElse: () => throw Exception('User not found'),
    );

    final userId = userJson['id'] as String;

    final orgJson = List<Map<String, dynamic>>.from(
      data['organizations'],
    ).firstWhere(
          (item) => item['id'] == orgId,
      orElse: () => throw Exception('Organization not found'),
    );

    final memberJson = List<Map<String, dynamic>>.from(
      data['org_members'],
    ).firstWhere(
          (item) =>
      item['user_id'] == userId &&
          item['org_id'] == orgId,
      orElse: () => throw Exception(
        'Organization membership not found',
      ),
    );

    final tokenResponse =
    authMock['mock_login_response'] as Map<String, dynamic>;

    return ResLogin(
      user: UserModel.fromJson(userJson),
      organization: OrgModel.fromJson(orgJson),
      membership: OrgMemberModel.fromJson(memberJson),
      accessToken: tokenResponse['access_token'] as String,
      refreshToken: tokenResponse['refresh_token'] as String,
    );
  }

  /// Refresh the mock access token.
  Future<String> refreshToken(String refreshToken) async {
    await _simulateRequest();

    final data = await _loadData();

    final authMock = data['auth_mock'] as Map<String, dynamic>;

    final tokenResponse =
    authMock['mock_login_response'] as Map<String, dynamic>;

    final storedRefreshToken =
    tokenResponse['refresh_token'] as String;

    if (refreshToken != storedRefreshToken) {
      throw Exception('Invalid refresh token');
    }

    return tokenResponse['access_token'] as String;
  }

  /// Get dashboard data.
  Future<ResDashboard> getDashboard() async {
    await _simulateRequest();

    final data = await _loadData();

    final projects = (data['projects'] as List)
        .map(
          (item) => ProjectModel.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();

    final tasks = (data['tasks'] as List)
        .map(
          (item) => TaskModel.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();

    return ResDashboard(
      projects: projects,
      tasks: tasks,
    );
  }

  /// Get user profile.
  Future<ResProfile> getProfile({
    required String userId,
    required String organizationId,
  }) async {
    await _simulateRequest();

    final data = await _loadData();

    final userJson = List<Map<String, dynamic>>.from(
      data['users'],
    ).firstWhere(
          (item) => item['id'] == userId,
      orElse: () => throw Exception('User not found'),
    );

    final organizationJson =
    List<Map<String, dynamic>>.from(
      data['organizations'],
    ).firstWhere(
          (item) => item['id'] == organizationId,
      orElse: () => throw Exception(
        'Organization not found',
      ),
    );

    final membershipJson =
    List<Map<String, dynamic>>.from(
      data['org_members'],
    ).firstWhere(
          (item) =>
      item['user_id'] == userId &&
          item['org_id'] == organizationId,
      orElse: () => throw Exception(
        'Organization membership not found',
      ),
    );

    return ResProfile(
      user: UserModel.fromJson(userJson),
      organization: OrgModel.fromJson(organizationJson),
      membership: OrgMemberModel.fromJson(membershipJson),
    );
  }

  /// Get all projects. Previously loaded projects remain available while offline.
  Future<List<ResProject>> getProjects() async {
    await _simulateRequest(
      allowCachedData: _projects != null,
    );

    final projects = await _getProjectsData();

    return projects
        .map((json) => ResProject.fromJson(json))
        .toList();
  }

  /// Get project by ID. Previously loaded projects remain available while offline.
  Future<ResProject> getProjectById(String projectId) async {
    await _simulateRequest(
      allowCachedData: _projects != null,
    );

    final projects = await _getProjectsData();

    final project = projects.firstWhere(
          (item) => item['id'] == projectId,
      orElse: () => throw Exception('Project not found'),
    );

    return ResProject.fromJson(project);
  }

  /// Create a new project.
  Future<ResProject> createProject({
    required String organizationId,
    required ReqCreateProject request,
  }) async {
    await _simulateRequest();

    final projects = await _getProjectsData();

    final project = <String, dynamic>{
      'id': 'proj_${DateTime.now().millisecondsSinceEpoch}',
      'org_id': organizationId,
      'name': request.name.trim(),
      'description': request.description.trim(),
      'task_count': 0,
      'status': 'active',
      'created_at': DateTime.now().toUtc().toIso8601String(),
    };

    projects.add(project);

    return ResProject.fromJson(project);
  }

  /// Update an existing project.
  Future<ResProject> updateProject({
    required String projectId,
    required ReqUpdateProject request,
  }) async {
    await _simulateRequest();

    final projects = await _getProjectsData();

    final index = projects.indexWhere(
          (item) => item['id'] == projectId,
    );

    if (index == -1) {
      throw Exception('Project not found');
    }

    projects[index] = {
      ...projects[index],
      'name': request.name.trim(),
      'description': request.description.trim(),
    };

    return ResProject.fromJson(projects[index]);
  }

  /// Delete an existing project.
  Future<void> deleteProject({
    required String projectId,
  }) async {
    await _simulateRequest();

    final projects = await _getProjectsData();

    final index = projects.indexWhere(
          (item) => item['id'] == projectId,
    );

    if (index == -1) {
      throw Exception('Project not found');
    }

    projects.removeAt(index);
  }

  /// Load projects into memory once.
  Future<List<Map<String, dynamic>>> _getProjectsData() async {
    if (_projects != null) {
      return _projects!;
    }

    final data = await _loadData();

    _projects = List<Map<String, dynamic>>.from(
      data['projects'],
    );

    return _projects!;
  }

  /// Get tasks optionally filtered by project. Previously loaded tasks remain available while offline.
  Future<List<ResTask>> getTasks({
    String? projectId,
  }) async {
    await _simulateRequest(
      allowCachedData: _tasks != null,
    );

    final tasks = await _getTasksData();

    final filteredTasks =
    projectId == null || projectId.isEmpty
        ? tasks
        : tasks
        .where(
          (task) => task['project_id'] == projectId,
    )
        .toList();

    return filteredTasks
        .map((json) => ResTask.fromJson(json))
        .toList();
  }

  /// Get task by ID. Previously loaded tasks remain available while offline.
  Future<ResTask> getTaskById(String taskId) async {
    await _simulateRequest(
      allowCachedData: _tasks != null,
    );

    final tasks = await _getTasksData();

    final task = tasks.firstWhere(
          (item) => item['id'] == taskId,
      orElse: () => throw Exception('Task not found'),
    );

    return ResTask.fromJson(task);
  }

  /// Create a new task.
  Future<ResTask> createTask({
    required ReqCreateTask request,
  }) async {
    await _simulateRequest();

    final tasks = await _getTasksData();
    final projects = await _getProjectsData();

    if (request.assigneeId != null) {
      await _validateOrganizationUser(
        request.assigneeId!,
      );
    }

    final projectIndex = projects.indexWhere(
          (project) => project['id'] == request.projectId,
    );

    if (projectIndex == -1) {
      throw Exception('Project not found');
    }

    final task = <String, dynamic>{
      'id': 'task_${DateTime.now().millisecondsSinceEpoch}',
      'project_id': request.projectId,
      'title': request.title.trim(),
      'description': request.description.trim(),
      'status': request.status,
      'priority': request.priority,
      'assignee_id': request.assigneeId,
      'due_date': request.dueDate,
    };

    tasks.add(task);

    projects[projectIndex]['task_count'] =
        (projects[projectIndex]['task_count'] ?? 0) + 1;

    return ResTask.fromJson(task);
  }

  /// Update an existing task.
  Future<ResTask> updateTask({
    required String taskId,
    required ReqUpdateTask request,
  }) async {
    await _simulateRequest();

    final tasks = await _getTasksData();

    final index = tasks.indexWhere(
          (item) => item['id'] == taskId,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    if (request.assigneeId != null) {
      await _validateOrganizationUser(
        request.assigneeId!,
      );
    }

    tasks[index] = {
      ...tasks[index],
      'title': request.title.trim(),
      'description': request.description.trim(),
      'status': request.status,
      'priority': request.priority,
      'assignee_id': request.assigneeId,
      'due_date': request.dueDate,
    };

    return ResTask.fromJson(tasks[index]);
  }

  /// Delete an existing task.
  Future<void> deleteTask({
    required String taskId,
  }) async {
    await _simulateRequest();

    final tasks = await _getTasksData();
    final projects = await _getProjectsData();

    final index = tasks.indexWhere(
          (item) => item['id'] == taskId,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    final projectId = tasks[index]['project_id'];

    tasks.removeAt(index);

    final projectIndex = projects.indexWhere(
          (project) => project['id'] == projectId,
    );

    if (projectIndex != -1) {
      final currentCount =
      (projects[projectIndex]['task_count'] ?? 0) as int;

      projects[projectIndex]['task_count'] =
      currentCount > 0 ? currentCount - 1 : 0;
    }
  }

  /// Update task status.
  Future<ResTask> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    await _simulateRequest();

    final tasks = await _getTasksData();

    final index = tasks.indexWhere(
          (item) => item['id'] == taskId,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    tasks[index] = {
      ...tasks[index],
      'status': status,
    };

    return ResTask.fromJson(tasks[index]);
  }

  /// Update task priority.
  Future<ResTask> updateTaskPriority({
    required String taskId,
    required String priority,
  }) async {
    await _simulateRequest();

    final tasks = await _getTasksData();

    final index = tasks.indexWhere(
          (item) => item['id'] == taskId,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    tasks[index] = {
      ...tasks[index],
      'priority': priority,
    };

    return ResTask.fromJson(tasks[index]);
  }

  /// Assign or unassign a task.
  Future<ResTask> assignTask({
    required String taskId,
    required ReqAssignTask request,
  }) async {
    await _simulateRequest();

    final tasks = await _getTasksData();

    final index = tasks.indexWhere(
          (item) => item['id'] == taskId,
    );

    if (index == -1) {
      throw Exception('Task not found');
    }

    if (request.assigneeId != null) {
      await _validateOrganizationUser(
        request.assigneeId!,
      );
    }

    tasks[index] = {
      ...tasks[index],
      'assignee_id': request.assigneeId,
    };

    return ResTask.fromJson(tasks[index]);
  }

  /// Get users for task assignment.
  Future<List<ResTaskUser>> getUsers() async {
    await _simulateRequest();

    final data = await _loadData();

    final users = List<Map<String, dynamic>>.from(
      data['users'],
    );

    return users
        .map((json) => ResTaskUser.fromJson(json))
        .toList();
  }

  /// Validate that the assigned user exists.
  Future<void> _validateOrganizationUser(
      String userId,
      ) async {
    await _simulateRequest();

    final data = await _loadData();

    final users = List<Map<String, dynamic>>.from(
      data['users'],
    );

    final exists = users.any(
          (user) => user['id'] == userId,
    );

    if (!exists) {
      throw Exception(
        'User does not belong to the organization',
      );
    }
  }

  /// Load tasks into memory once.
  Future<List<Map<String, dynamic>>> _getTasksData() async {
    if (_tasks != null) {
      return _tasks!;
    }

    final data = await _loadData();

    _tasks = List<Map<String, dynamic>>.from(
      data['tasks'],
    );

    return _tasks!;
  }
}