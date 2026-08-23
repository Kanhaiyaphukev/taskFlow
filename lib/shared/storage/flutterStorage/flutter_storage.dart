import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterStorage {
  FlutterSecureStorage? _storage;

  FlutterStorage() {
    _storage = const FlutterSecureStorage();
  }

  Future<String?> readStorage(String key) async {
    return await _storage?.read(key: key);
  }

  Future<void> writeStorage(String key, String value) async {
    await _storage?.write(key: key, value: value);
  }

  Future<void> deleteStorage(String key) async {
    await _storage?.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage?.deleteAll();
  }
}
