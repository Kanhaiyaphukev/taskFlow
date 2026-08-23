part of 'app_pages.dart';

class AppRoutes {
  AppRoutes._internal();

  static final AppRoutes _instance = AppRoutes._internal();

  factory AppRoutes() {
    return _instance;
  }

  final String splashView = '/';
  final String loginView = '/loginView';
  final String registerView = '/registerView';
  final String dashboardView = '/dashboardView';
  final String profileView = '/profileView';
  final String projectView = '/projectView';
  final String projectDetailsView = '/projectDetailsView';
  final String taskView = '/taskView';
  final String taskDetailsView = '/taskDetailsView';
}
