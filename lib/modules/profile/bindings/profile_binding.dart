import 'package:get/get.dart';
import '../../../data/dataSources/mock_data_source.dart';
import '../controllers/profile_controller.dart';
import '../repositories/profile_repo.dart';
import '../repositories/profile_repo_impl.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(
          () => ProfileRepositoryImpl(
        dataSource: Get.find<MockDataSource>(),
      ),
    );

    Get.lazyPut<ProfileController>(
          () => ProfileController(
        repository: Get.find<ProfileRepository>(),
      ),
    );


  }
}