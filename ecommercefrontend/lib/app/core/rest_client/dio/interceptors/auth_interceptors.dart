import 'package:dio/dio.dart';
import 'package:ecommercefrontend/app/core/helpers/constants/constants.dart';
import 'package:ecommercefrontend/app/core/helpers/environments.dart';
import 'package:ecommercefrontend/app/core/local_storage/local_storage.dart';

class AuthInterceptors extends Interceptor {
  final LocalStorage _localStorage;
  AuthInterceptors({required LocalStorage localStorage})
    : _localStorage = localStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authRequired = options.extra['required_true'] ?? false;
    if (authRequired) {
      final accessToken = await _localStorage.read<String>(
        Constants.ACCESS_TOKEN_KEY,
      );
      if (accessToken == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'expire token',
            type: DioExceptionType.cancel,
          ),
        );
      }
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _localStorage.read<String>(
        Constants.REFRESH_TOKEN_KEY,
      );
      if (refreshToken != null) {
        try {
          final dio = Dio(
            BaseOptions(
              baseUrl: Environments.param(Constants.ENV_BASE_URL) ?? '',
            ),
          );
          final response = await dio.post(
            Constants.API_AUTH_REFRESH,
            data: {'refresh_token': refreshToken},
          );

          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];

          await _localStorage.write(Constants.ACCESS_TOKEN_KEY, newAccessToken);
          await _localStorage.write(
            Constants.REFRESH_TOKEN_KEY,
            newRefreshToken,
          );

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await dio.fetch(options);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed, logout
          await _localStorage.clear();
          return handler.reject(err);
        }
      }
    }
    super.onError(err, handler);
  }
}
