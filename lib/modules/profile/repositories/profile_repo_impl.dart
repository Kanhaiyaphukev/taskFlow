import '../../../data/dataSources/mock_data_source.dart';
import '../models/response/res_profile.dart';
import 'profile_repo.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final MockDataSource dataSource;

  ProfileRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<ResProfile> getProfile({
    required String userId,
    required String organizationId,
  }) async {
    return await dataSource.getProfile(
      userId: userId,
      organizationId: organizationId,
    );
  }
}