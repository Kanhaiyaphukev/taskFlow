class FlutterStorageKeys {
  FlutterStorageKeys._internal();

  static final FlutterStorageKeys _instance = FlutterStorageKeys._internal();

  factory FlutterStorageKeys() {
    return _instance;
  }

  final String accessToken = 'accessToken';
  final String refreshToken = 'refreshToken';
  final String accessTokenExpiresAt = 'accessTokenExpiresAt';
  final String role = 'role';
  final String userId = 'userId';
  final String userName = 'userName';
  final String userAvatarUrl = 'userAvatarUrl';
  final String organizationId = 'organizationId';
  final String organizationName = 'organizationName';
  final String createTask = '';
}
