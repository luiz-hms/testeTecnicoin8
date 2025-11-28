class UpdateClientSettingsRequestModel {
  final String? primaryColor;
  final String? secondaryColor;
  final String? name;

  UpdateClientSettingsRequestModel({
    this.primaryColor,
    this.secondaryColor,
    this.name,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (primaryColor != null) data['primaryColor'] = primaryColor;
    if (secondaryColor != null) data['secondaryColor'] = secondaryColor;
    if (name != null) data['name'] = name;
    return data;
  }
}
