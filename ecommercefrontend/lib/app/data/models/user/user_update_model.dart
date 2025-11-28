class UserUpdateModel {
  final String? name;
  final String? password;

  UserUpdateModel({this.name, this.password});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (password != null) map['password'] = password;
    return map;
  }
}
