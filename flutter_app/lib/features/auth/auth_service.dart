import 'package:skillswap_app/utils/storage_helper.dart';
import 'package:skillswap_app/services/api_service.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final response = await ApiService.login(email, password);

    // ❌ LOGIN FAILED
    if (response['token'] == null) {
      throw Exception(response['message'] ?? 'Login failed');
    }

    // ✅ LOGIN SUCCESS
    final token = response['token'];
    final userId = response['userId'];

    await StorageHelper.saveAuthData(token, userId);

    return true;
  }
}
