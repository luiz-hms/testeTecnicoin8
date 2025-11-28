class WhitelabelStoreResponseModel {
  final String id;
  final String name;
  final String baseUrl;
  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;
  final List<String>? bannerImages;

  WhitelabelStoreResponseModel({
    required this.id,
    required this.name,
    required this.baseUrl,
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
    this.bannerImages,
  });

  factory WhitelabelStoreResponseModel.fromJson(Map<String, dynamic> json) {
    List<String>? bannerUrls;
    if (json['bannerImages'] != null) {
      final banners = json['bannerImages'] as List<dynamic>;
      bannerUrls = banners
          .where((banner) => banner['url'] != null)
          .map((banner) => banner['url'] as String)
          .toList();
    }

    String? logoUrl;
    if (json['logo'] != null && json['logo']['url'] != null) {
      logoUrl = json['logo']['url'] as String;
    }

    return WhitelabelStoreResponseModel(
      id: json['id'] as String,
      name: json['shopName'] as String,
      baseUrl: json['baseUrl'] as String,
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      logoUrl: logoUrl,
      bannerImages: bannerUrls,
    );
  }
}
