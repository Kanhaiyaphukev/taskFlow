import '../models/response/res_dashboard.dart';

abstract class DashboardRepository {
  Future<ResDashboard> getDashboard();
}