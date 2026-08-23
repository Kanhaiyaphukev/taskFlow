import 'package:get/get.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/response/res_dashboard.dart';
import '../repositories/dashboard_repo.dart';

class DashboardController extends GetxController {
  final DashboardRepository repository;
  DashboardController({required this.repository});
  final FlutterStorage storage = FlutterStorage();
  final FlutterStorageKeys keys = FlutterStorageKeys();
  final userName = ''.obs;
  final userAvatarUrl = ''.obs;
  final role = ''.obs;
  final isLoading = false.obs;
  final isDataLoaded = false.obs;
  final dashboardData = Rxn<ResDashboard>();
  DateTime? lastRefreshTime;

  @override
  void onInit() {
    super.onInit();
    getDashboardData();
  }

  /// Load dashboard data
  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;
      isDataLoaded.value = false;
      await getUserData();
      final response = await repository.getDashboard();
      dashboardData.value = response;
      lastRefreshTime = DateTime.now();
      isDataLoaded.value = true;
    } catch (e) {
      isDataLoaded.value = false;

      final message = e.toString().replaceFirst(
        'Exception: ',
        '',
      );
      AppToast.errorToast(message);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get logged-in user data from storage
  Future<void> getUserData() async {
    userName.value = await storage.readStorage(keys.userName) ?? '';
    userAvatarUrl.value = await storage.readStorage(keys.userAvatarUrl) ?? '';
    role.value = await storage.readStorage(keys.role) ?? '';
  }

  /// Total projects
  int get totalProjects => dashboardData.value?.projects.length ?? 0;

  /// Active projects
  int get activeProjects =>
      dashboardData.value?.projects
          .where((project) => project.status == 'active')
          .length ??
      0;

  /// Total tasks
  int get totalTasks => dashboardData.value?.tasks.length ?? 0;

  /// Todo tasks
  int get todoTasks =>
      dashboardData.value?.tasks
          .where((task) => task.status == 'todo')
          .length ??
      0;

  /// In-progress tasks
  int get inProgressTasks =>
      dashboardData.value?.tasks
          .where((task) => task.status == 'in_progress')
          .length ??
      0;

  /// Review tasks
  int get reviewTasks =>
      dashboardData.value?.tasks
          .where((task) => task.status == 'review')
          .length ??
      0;

  /// Completed tasks
  int get completedTasks =>
      dashboardData.value?.tasks
          .where((task) => task.status == 'done')
          .length ??
      0;

  /// Completed projects
  int get completedProjects =>
      dashboardData.value?.projects
          .where((project) => project.status == 'completed')
          .length ??
      0;
}
