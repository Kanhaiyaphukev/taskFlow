import '../../../shared/storage/flutterStorage/flutter_storage.dart';
import '../../../shared/storage/flutterStorage/flutter_storage_keys.dart';
import '../repositories/auth_repo.dart';

class AuthSessionService {
  final AuthRepository repository;
  final FlutterStorage storage;
  final FlutterStorageKeys keys;

  AuthSessionService({
    required this.repository,
    required this.storage,
    required this.keys,
  });

  /// Check current session
  Future<bool> checkSession() async {
    final accessToken = await storage.readStorage(keys.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    final isExpired = await isAccessTokenExpired();

    if (!isExpired) {
      return true;
    }

    return await refreshSession();
  }

  /// Check access token expiry
  Future<bool> isAccessTokenExpired() async {
    final expiresAtString = await storage.readStorage(
      keys.accessTokenExpiresAt,
    );

    if (expiresAtString == null || expiresAtString.isEmpty) {
      return true;
    }

    final expiresAt = DateTime.tryParse(expiresAtString);

    if (expiresAt == null) {
      return true;
    }

    return !DateTime.now().isBefore(expiresAt);
  }

  /// Refresh expired access token
  Future<bool> refreshSession() async {
    final refreshToken = await storage.readStorage(keys.refreshToken);

    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final newAccessToken = await repository.refreshToken(refreshToken);

      await storage.writeStorage(keys.accessToken, newAccessToken);

      final expiresAt = DateTime.now()
          .add(const Duration(minutes: 15))
          .toIso8601String();

      await storage.writeStorage(keys.accessTokenExpiresAt, expiresAt);

      return true;
    } catch (_) {
      await clearSession();
      return false;
    }
  }

  /// Clear current session
  Future<void> clearSession() async {
    await storage.clearAll();
  }
}
