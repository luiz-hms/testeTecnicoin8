class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String shopName;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.shopName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'shopName': shopName,
    };
  }
}
