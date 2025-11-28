import 'package:ecommercefrontend/app/core/rest_client/rest_client.dart';
import 'package:ecommercefrontend/app/core/rest_client/rest_client_exception.dart';
import 'package:ecommercefrontend/app/core/helpers/constants/constants.dart';
import 'package:ecommercefrontend/app/data/models/user/user_model.dart';
import 'package:ecommercefrontend/app/data/models/user/update_user_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;

  UserRepositoryImpl({required RestClient restClient})
    : _restClient = restClient;

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final result = await _restClient.auth().get(Constants.API_USERS_ME);
      return UserModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<UserModel> updateProfile(UpdateUserRequestModel updateData) async {
    try {
      final result = await _restClient.auth().put(
        Constants.API_USERS_ME,
        data: updateData.toJson(),
      );
      return UserModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    try {
      final file = File(filePath);
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final result = await _restClient.auth().post(
        Constants.API_USERS_PROFILE_PHOTO,
        data: formData,
      );

      return result.data as Map<String, dynamic>;
    } on RestClientException catch (e) {
      throw e;
    }
  }
}
