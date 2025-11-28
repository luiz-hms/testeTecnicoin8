import 'package:ecommercefrontend/app/data/models/auth/login_request_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/login_response_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/refresh_token_request_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/refresh_token_response_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/register_request_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/register_response_model.dart';
import 'package:ecommercefrontend/app/data/models/auth/whitelabel_store_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel loginRequest);
  Future<RefreshTokenResponseModel> refreshToken(
    RefreshTokenRequestModel refreshTokenRequest,
  );
  Future<RegisterResponseModel> register(RegisterRequestModel registerRequest);
  Future<WhitelabelStoreResponseModel> getWhitelabelStore(String baseUrl);
}
