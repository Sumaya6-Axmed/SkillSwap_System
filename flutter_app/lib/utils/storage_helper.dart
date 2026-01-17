import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static final _box = GetStorage();

  static Future<void> saveAuth({
    required String token,
    required String userId,
    String? email,
  }) async {
    await _box.write("token", token);
    await _box.write("userId", userId);
    if (email != null) await _box.write("email", email);
  }

  static String? token() => _box.read("token");
  static String? userId() => _box.read("userId");
  static String? email() => _box.read("email");

  static Future<void> logout() async {
    await _box.remove("token");
    await _box.remove("userId");
    await _box.remove("email");
  }

  // ✅ compatibility with your old code:
  static String? getToken() => token();
  static String? getUserId() => userId();

  static Future<void> saveAuthData(
    String token,
    String userId, {
    String? email,
  }) async {
    await saveAuth(token: token, userId: userId, email: email);
  }
}
