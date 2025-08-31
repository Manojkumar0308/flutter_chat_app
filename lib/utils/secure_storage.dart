import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveUser(String userId, String token) async {
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> clearUser() async {
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'token');
  }
}
