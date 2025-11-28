class UpdateUserRequestModel {
  final String? name;
  final String? email;
  final String? password;

  UpdateUserRequestModel({this.name, this.email, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    return data;
  }
}
