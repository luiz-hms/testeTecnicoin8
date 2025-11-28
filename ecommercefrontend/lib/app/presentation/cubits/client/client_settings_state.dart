import 'package:ecommercefrontend/app/data/models/client/client_settings_model.dart';

enum ClientSettingsStatus { initial, loading, loaded, error, updateSuccess }

abstract class ClientSettingsState {
  final ClientSettingsModel? settings;
  final ClientSettingsStatus status;
  final String? errorMessage;

  const ClientSettingsState({
    this.settings,
    required this.status,
    this.errorMessage,
  });
}

class ClientSettingsInitial extends ClientSettingsState {
  const ClientSettingsInitial() : super(status: ClientSettingsStatus.initial);
}

class ClientSettingsUpdated extends ClientSettingsState {
  const ClientSettingsUpdated({
    super.settings,
    required super.status,
    super.errorMessage,
  });

  ClientSettingsUpdated copyWith({
    ClientSettingsModel? settings,
    ClientSettingsStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ClientSettingsUpdated(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
