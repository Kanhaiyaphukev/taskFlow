import 'package:get/get.dart';
import '../../../data/dataSources/mock_data_source.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../controllers/auth_controller.dart';
import '../repositories/auth_repo.dart';
import '../repositories/auth_repo_impl.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(
        dataSource: Get.find<MockDataSource>(),
        storage: Get.find<FlutterStorage>(),
      ),
      fenix: true,
    );

    Get.put<AuthController>(
      AuthController(
        repository: Get.find<AuthRepository>(),
      ),
      permanent: true,
    );
  }
}