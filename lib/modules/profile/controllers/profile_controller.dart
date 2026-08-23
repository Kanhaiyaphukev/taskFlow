import 'package:get/get.dart';
import '../../../shared/routes/app_pages.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/response/res_profile.dart';
import '../repositories/profile_repo.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository;
  ProfileController({
    required this.repository,
  });
  final FlutterStorage storage = FlutterStorage();
  final FlutterStorageKeys keys = FlutterStorageKeys();
  final isLoading = false.obs;
  final profile = Rxn<ResProfile>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  /// Load logged-in user's profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final userId = await storage.readStorage(keys.userId);
      final organizationId = await storage.readStorage(
        keys.organizationId,
      );

      if (userId == null || organizationId == null) {
        throw Exception('User information not available');
      }

      final response = await repository.getProfile(
        userId: userId,
        organizationId: organizationId,
      );

      profile.value = response;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await storage.clearAll();
    AppToast.successToast('Logged out successfully');
    await Get.offAllNamed(
      AppRoutes().loginView,
    );
  }
}