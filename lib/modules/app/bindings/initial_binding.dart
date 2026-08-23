import 'package:get/get.dart';
import '../../../data/dataSources/mock_data_source.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MockDataSource>(
      MockDataSource(),
      permanent: true,
    );

    Get.put<FlutterStorage>(
      FlutterStorage(),
      permanent: true,
    );
  }
}