import '../routes/import.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._internal();

  static final AppPages _instance = AppPages._internal();

  factory AppPages() {
    return _instance;
  }

  List<GetPage> routes = [
    GetPage(
      name: AppRoutes().splashView,
      page: () => const SplashView(),
      binding: AppBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().loginView,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().registerView,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().dashboardView,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().profileView,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().projectView,
      page: () => const ProjectView(),
      binding: ProjectBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().projectDetailsView,
      page: () => const ProjectDetailsView(),
      binding: ProjectBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().taskView,
      page: () => const TaskView(),
      binding: TaskBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes().taskDetailsView,
      page: () => const TaskDetailsView(),
      binding: TaskBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
