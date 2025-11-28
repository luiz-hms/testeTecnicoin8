import 'package:ecommercefrontend/app/core/rest_client/rest_client.dart';
import 'package:ecommercefrontend/app/core/rest_client/rest_client_exception.dart';
import 'package:ecommercefrontend/app/core/helpers/constants/constants.dart';
import 'package:ecommercefrontend/app/data/models/auth/login_request_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/login_response_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/refresh_token_request_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/refresh_token_response_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/register_request_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/register_response_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/whitelabel_store_response_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RestClient _restClient;

  AuthRepositoryImpl({required RestClient restClient})
    : _restClient = restClient;

  @override
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    try {
      final result = await _restClient.unauth().post(
        Constants.API_AUTH_LOGIN,
        data: loginRequest.toJson(),
      );
      return LoginResponseModel.fromJson(result.data);
    } on RestClientException catch (e) {
      // Log error or handle specific status codes if needed
      throw e;
    }
  }

  @override
  Future<RefreshTokenResponseModel> refreshToken(
    RefreshTokenRequestModel refreshTokenRequest,
  ) async {
    try {
      final result = await _restClient.unauth().post(
        Constants.API_AUTH_REFRESH,
        data: refreshTokenRequest.toJson(),
      );
      return RefreshTokenResponseModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<RegisterResponseModel> register(
    RegisterRequestModel registerRequest,
  ) async {
    try {
      final result = await _restClient.unauth().post(
        Constants.API_AUTH_REGISTER,
        data: registerRequest.toJson(),
      );
      return RegisterResponseModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<WhitelabelStoreResponseModel> getWhitelabelStore(
    String baseUrl,
  ) async {
    try {
      final result = await _restClient.unauth().get(
        Constants.getWhitelabelEndpoint(baseUrl),
      );
      return WhitelabelStoreResponseModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }
}
