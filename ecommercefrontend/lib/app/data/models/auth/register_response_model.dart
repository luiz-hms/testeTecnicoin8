class RegisterResponseModel {
  final String userId;
  final String clientId;
  final String accessToken;
  final String refreshToken;
  final String message;

  RegisterResponseModel({
    required this.userId,
    required this.clientId,
    required this.accessToken,
    required this.refreshToken,
    required this.message,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      userId: json['userId'] as String,
      clientId: json['clientId'] as String,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      message: json['message'] as String? ?? 'Registro realizado com sucesso',
    );
  }
}
