import 'package:ecommercefrontend/app/core/rest_client/rest_client.dart';
import 'package:ecommercefrontend/app/core/rest_client/rest_client_exception.dart';
import 'package:ecommercefrontend/app/core/helpers/constants/constants.dart';
import 'package:ecommercefrontend/app/data/models/client/client_settings_model.dart';
import 'package:ecommercefrontend/app/data/models/client/update_client_settings_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/client_repository.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class ClientRepositoryImpl implements ClientRepository {
  final RestClient _restClient;

  ClientRepositoryImpl({required RestClient restClient})
    : _restClient = restClient;

  @override
  Future<ClientSettingsModel> getClientSettings(String clientId) async {
    try {
      final result = await _restClient.auth().get(
        Constants.getClientEndpoint(clientId),
      );
      return ClientSettingsModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<ClientSettingsModel> updateClientSettings(
    String clientId,
    UpdateClientSettingsRequestModel settings,
  ) async {
    try {
      final result = await _restClient.auth().put(
        Constants.getClientSettingsEndpoint(clientId),
        data: settings.toJson(),
      );
      return ClientSettingsModel.fromJson(result.data);
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>> uploadLogo(
    String clientId,
    String filePath,
  ) async {
    try {
      final file = File(filePath);
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final result = await _restClient.auth().post(
        Constants.getClientLogoEndpoint(clientId),
        data: formData,
      );

      return result.data as Map<String, dynamic>;
    } on RestClientException catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>> uploadBannerImages(
    String clientId,
    List<String> filePaths,
  ) async {
    try {
      final files = await Future.wait(
        filePaths.map((path) async {
          final file = File(path);
          return MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
        }),
      );

      final formData = FormData.fromMap({'files': files});

      final result = await _restClient.auth().post(
        Constants.getClientBannerImagesEndpoint(clientId),
        data: formData,
      );

      return result.data as Map<String, dynamic>;
    } on RestClientException catch (e) {
      throw e;
    }
  }
}
