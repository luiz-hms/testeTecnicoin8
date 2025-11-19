import 'package:dio/dio.dart';
import 'package:ecommercefrontend/app/core/rest_client/rest_client_response.dart';

import '../rest_client.dart';

class DioRestClient implements RestClient {
  late final Dio _dio;
  final _defaultOptions = BaseOptions(
    baseUrl: '',
    //baseUrl: Envarionments.param('base_url'),
  );

  DioRestClient() {
    _dio = Dio(_defaultOptions);
  }

  @override
  RestClient unauth() {
    // TODO: implement unauth
    throw UnimplementedError();
  }

  @override
  RestClient auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<RestClientResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<RestClientResponse<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement request
    throw UnimplementedError();
  }
}
