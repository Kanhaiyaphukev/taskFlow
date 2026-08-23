import 'package:get/get.dart';
import '../../auth/repositories/auth_repo.dart';
import '../../auth/repositories/auth_repo_impl.dart';
import '../../auth/services/auth_session_service.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../../../data/dataSources/mock_data_source.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../controllers/app_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
          () => AuthRepositoryImpl(
        dataSource: Get.find<MockDataSource>(),
        storage: Get.find<FlutterStorage>(),
      ),
    );

    Get.lazyPut<AuthSessionService>(
          () => AuthSessionService(
        repository: Get.find<AuthRepository>(),
        storage: Get.find<FlutterStorage>(),
        keys: FlutterStorageKeys(),
      ),
    );

    Get.lazyPut<AppController>(
          () => AppController(),
    );
  }
}