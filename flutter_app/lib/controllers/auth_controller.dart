import 'package:get/get.dart';
import 'package:skillswap_app/app/app_routes.dart';
import 'package:skillswap_app/utils/storage_helper.dart';

class AuthController extends GetxController {
  Future<void> logout() async {
    await StorageHelper.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
