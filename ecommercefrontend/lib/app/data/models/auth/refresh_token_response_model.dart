class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;

  RefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}
