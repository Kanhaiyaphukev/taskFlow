import '../../../data/dataSources/mock_data_source.dart';
import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../models/request/req_login.dart';
import '../models/response/response_login.dart';
import 'auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockDataSource dataSource;
  final FlutterStorage storage;

  AuthRepositoryImpl({required this.dataSource, required this.storage});

  /// Login
  @override
  Future<ResLogin> login(ReqLogin request) async {
    final response = await dataSource.login(request);

    final keys = FlutterStorageKeys();

    await storage.writeStorage(keys.accessToken, response.accessToken);

    await storage.writeStorage(keys.refreshToken, response.refreshToken);

    final expiresAt = DateTime.now()
        .add(const Duration(minutes: 15))
        .toIso8601String();

    await storage.writeStorage(keys.accessTokenExpiresAt, expiresAt);

    await storage.writeStorage(keys.userId, response.user.id);

    await storage.writeStorage(keys.userName, response.user.name);

    await storage.writeStorage(keys.userAvatarUrl, response.user.avatarUrl ?? '');

    await storage.writeStorage(keys.organizationId, response.organization.id);

    await storage.writeStorage(
      keys.organizationName,
      response.organization.name,
    );

    await storage.writeStorage(keys.role, response.membership.role);

    return response;
  }

  /// Refresh access token
  @override
  Future<String> refreshToken(String refreshToken) async {
    return await dataSource.refreshToken(refreshToken);
  }
}
