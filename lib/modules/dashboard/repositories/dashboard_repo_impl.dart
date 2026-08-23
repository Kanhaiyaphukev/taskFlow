import '../../../data/dataSources/mock_data_source.dart';
import '../models/response/res_dashboard.dart';
import 'dashboard_repo.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final MockDataSource dataSource;

  DashboardRepositoryImpl({
    required this.dataSource,
  });

  /// Get dashboard data
  @override
  Future<ResDashboard> getDashboard() async {
    return await dataSource.getDashboard();
  }
}