import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:task_flow/modules/projects/models/response/res_project.dart';
import 'package:task_flow/modules/tasks/controllers/task_controller.dart';
import 'package:task_flow/modules/tasks/models/request/req_create_task.dart';
import 'package:task_flow/modules/tasks/models/request/req_update_task.dart';
import 'package:task_flow/modules/tasks/models/request/res_assign_task.dart';
import 'package:task_flow/modules/tasks/models/response/res_task.dart';
import 'package:task_flow/modules/tasks/models/response/res_task_user.dart';
import 'package:task_flow/modules/tasks/repositories/task_repo.dart';
import 'package:task_flow/modules/tasks/views/task_view.dart';

class FakeTaskRepository implements TaskRepository {
  @override
  Future<List<ResTask>> getTasks({String? projectId}) async {
    return [];
  }

  @override
  Future<List<ResProject>> getProjects() async {
    return [];
  }

  @override
  Future<List<ResTaskUser>> getUsers() async {
    return [];
  }

  @override
  Future<ResTask> getTaskById(String taskId) async {
    throw UnimplementedError();
  }

  @override
  Future<ResTask> createTask(ReqCreateTask request) async {
    throw UnimplementedError();
  }

  @override
  Future<ResTask> updateTask(String taskId, ReqUpdateTask request) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(String taskId) async {
    throw UnimplementedError();
  }

  @override
  Future<ResTask> updateTaskStatus(String taskId, String status) async {
    throw UnimplementedError();
  }

  @override
  Future<ResTask> updateTaskPriority(String taskId, String priority) async {
    throw UnimplementedError();
  }

  @override
  Future<ResTask> assignTask(String taskId, ReqAssignTask request) async {
    throw UnimplementedError();
  }
}

class TestTaskController extends TaskController {
  TestTaskController({required super.repository});
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Task view displays empty state', (tester) async {
    final controller = TestTaskController(repository: FakeTaskRepository());

    Get.put<TaskController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: TaskView()));

    // Set the required UI state after mounting.
    controller.isLoading.value = false;
    controller.isDataLoaded.value = true;
    controller.filteredTasks.clear();

    await tester.pump();

    expect(find.text('No tasks found'), findsOneWidget);
  });
}
