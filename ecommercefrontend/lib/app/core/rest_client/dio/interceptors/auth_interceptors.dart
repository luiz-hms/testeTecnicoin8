import 'package:dio/dio.dart';

import '../../../local_storage/local_storage.dart';

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
      final accessToken = await _localStorage.read<String>('');
      if (accessToken == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'expire token',
            type: DioExceptionType.cancel,
          ),
        );
      }
      options.headers['Authorization'] = accessToken;
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   // TODO: implement onResponse
  //   super.onResponse(response, handler);
  // }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   // TODO: implement onError
  //   super.onError(err, handler);
  // }
}
