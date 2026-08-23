import 'package:get/get.dart';

import '../../../data/dataSources/mock_data_source.dart';
import '../controllers/project_controller.dart';
import '../repositories/project_repo.dart';
import '../repositories/project_repo_impl.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectRepository>(
          () => ProjectRepositoryImpl(
        dataSource: Get.find<MockDataSource>(),
      ),
    );

    Get.lazyPut<ProjectController>(
          () => ProjectController(
        repository: Get.find<ProjectRepository>(),
      ),
    );
  }
}