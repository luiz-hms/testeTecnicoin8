class ClientSettingsModel {
  final String id;
  final String name;
  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;
  final List<String>? bannerImages;
  final String? baseUrl;

  ClientSettingsModel({
    required this.id,
    required this.name,
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    this.bannerImages,
    this.baseUrl,
  });

  factory ClientSettingsModel.fromJson(Map<String, dynamic> json) {
    return ClientSettingsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      logoUrl: json['logoUrl'] as String?,
      bannerImages: (json['bannerImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      baseUrl: json['baseUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'logoUrl': logoUrl,
      'bannerImages': bannerImages,
      'baseUrl': baseUrl,
    };
  }
}
