import 'package:bloc/bloc.dart';
import 'package:ecommercefrontend/app/data/models/client/update_client_settings_request_model.dart';
import 'package:ecommercefrontend/app/domain/repositories/client_repository.dart';
import 'client_settings_state.dart';

class ClientSettingsCubit extends Cubit<ClientSettingsState> {
  final ClientRepository _clientRepository;

  ClientSettingsCubit({required ClientRepository clientRepository})
    : _clientRepository = clientRepository,
      super(const ClientSettingsInitial());

  /// Carregar configurações da loja
  Future<void> loadClientSettings(String clientId) async {
    emit(const ClientSettingsUpdated(status: ClientSettingsStatus.loading));

    try {
      final settings = await _clientRepository.getClientSettings(clientId);
      emit(
        ClientSettingsUpdated(
          settings: settings,
          status: ClientSettingsStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        ClientSettingsUpdated(
          status: ClientSettingsStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Atualizar configurações da loja
  Future<void> updateSettings(
    String clientId, {
    String? primaryColor,
    String? secondaryColor,
    String? name,
  }) async {
    if (state is ClientSettingsUpdated) {
      emit(
        (state as ClientSettingsUpdated).copyWith(
          status: ClientSettingsStatus.loading,
        ),
      );
    }

    try {
      final updateData = UpdateClientSettingsRequestModel(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        name: name,
      );

      final updatedSettings = await _clientRepository.updateClientSettings(
        clientId,
        updateData,
      );

      emit(
        ClientSettingsUpdated(
          settings: updatedSettings,
          status: ClientSettingsStatus.updateSuccess,
        ),
      );
    } catch (e) {
      if (state is ClientSettingsUpdated) {
        emit(
          (state as ClientSettingsUpdated).copyWith(
            status: ClientSettingsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  /// Upload de logo
  Future<void> uploadLogo(String clientId, String filePath) async {
    if (state is ClientSettingsUpdated) {
      emit(
        (state as ClientSettingsUpdated).copyWith(
          status: ClientSettingsStatus.loading,
        ),
      );
    }

    try {
      await _clientRepository.uploadLogo(clientId, filePath);
      // Recarregar configurações após upload
      await loadClientSettings(clientId);
    } catch (e) {
      if (state is ClientSettingsUpdated) {
        emit(
          (state as ClientSettingsUpdated).copyWith(
            status: ClientSettingsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  /// Upload de imagens de banner
  Future<void> uploadBannerImages(
    String clientId,
    List<String> filePaths,
  ) async {
    if (state is ClientSettingsUpdated) {
      emit(
        (state as ClientSettingsUpdated).copyWith(
          status: ClientSettingsStatus.loading,
        ),
      );
    }

    try {
      await _clientRepository.uploadBannerImages(clientId, filePaths);
      // Recarregar configurações após upload
      await loadClientSettings(clientId);
    } catch (e) {
      if (state is ClientSettingsUpdated) {
        emit(
          (state as ClientSettingsUpdated).copyWith(
            status: ClientSettingsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
