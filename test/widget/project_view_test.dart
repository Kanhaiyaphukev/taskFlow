import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:task_flow/modules/projects/controllers/project_controller.dart';
import 'package:task_flow/modules/projects/repositories/project_repo.dart';
import 'package:task_flow/modules/projects/models/request/req_create_project.dart';
import 'package:task_flow/modules/projects/models/request/req_update_project.dart';
import 'package:task_flow/modules/projects/models/response/res_project.dart';
import 'package:task_flow/modules/projects/views/project_view.dart';

class FakeProjectRepository implements ProjectRepository {
  @override
  Future<List<ResProject>> getProjects() async {
    return [];
  }

  @override
  Future<ResProject> getProjectById(String projectId) async {
    throw UnimplementedError();
  }

  @override
  Future<ResProject> createProject({
    required String organizationId,
    required ReqCreateProject request,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<ResProject> updateProject(
    String projectId,
    ReqUpdateProject request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProject(String projectId) async {
    throw UnimplementedError();
  }
}

class TestProjectController extends ProjectController {
  TestProjectController({required super.repository});
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Project view displays empty state', (tester) async {
    final controller = TestProjectController(
      repository: FakeProjectRepository(),
    );

    controller.isDataLoaded.value = true;
    controller.isLoading.value = false;
    controller.isOrgAdmin.value = false;

    Get.put<ProjectController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: ProjectView()));

    await tester.pump();

    expect(find.text('Projects'), findsOneWidget);

    expect(find.text('No projects found'), findsOneWidget);
  });
}
