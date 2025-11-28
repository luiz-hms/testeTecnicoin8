import '../../data/models/client/client_settings_model.dart';
import '../../data/models/client/update_client_settings_request_model.dart';

abstract class ClientRepository {
  Future<ClientSettingsModel> getClientSettings(String clientId);
  Future<ClientSettingsModel> updateClientSettings(
    String clientId,
    UpdateClientSettingsRequestModel settings,
  );
  Future<Map<String, dynamic>> uploadLogo(String clientId, String filePath);
  Future<Map<String, dynamic>> uploadBannerImages(
    String clientId,
    List<String> filePaths,
  );
}
