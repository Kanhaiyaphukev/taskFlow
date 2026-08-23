import 'package:get/get.dart';
import '../../../data/dataSources/mock_data_source.dart';
import '../controllers/task_controller.dart';
import '../repositories/task_repo.dart';
import '../repositories/task_repo_impl.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(
          () => TaskRepositoryImpl(
        dataSource: Get.find<MockDataSource>(),
      ),
    );

    Get.lazyPut<TaskController>(
          () => TaskController(
        repository: Get.find<TaskRepository>(),
      ),
    );
  }
}