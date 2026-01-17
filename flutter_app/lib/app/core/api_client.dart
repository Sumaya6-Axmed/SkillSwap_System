import 'package:dio/dio.dart';
import 'package:skillswap_app/utils/storage_helper.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:5000", // Android emulator
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final t = StorageHelper.token();
          if (t != null) options.headers["Authorization"] = "Bearer $t";
          handler.next(options);
        },
      ),
    );
}
