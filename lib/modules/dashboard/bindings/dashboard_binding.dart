import 'package:get/get.dart';
import '../../../data/dataSources/mock_data_source.dart';
import '../controllers/dashboard_controller.dart';
import '../repositories/dashboard_repo.dart';
import '../repositories/dashboard_repo_impl.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(
          () => DashboardRepositoryImpl(
        dataSource: Get.find<MockDataSource>(),
      ),
    );

    Get.lazyPut<DashboardController>(
          () => DashboardController(
        repository: Get.find<DashboardRepository>(),
      ),
    );
  }
}
