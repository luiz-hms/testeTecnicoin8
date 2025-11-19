import 'package:flutter/material.dart';
import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';

class ThemeModel extends AppTheme {
  const ThemeModel({
    required super.id,
    required super.name,
    required super.primaryColor,
    required super.accentColor,
    required super.logoUrl,
    required super.bannerUrls,
    required super.createdAt,
  });

  factory ThemeModel.fromEntity(AppTheme entity) {
    return ThemeModel(
      id: entity.id,
      name: entity.name,
      primaryColor: entity.primaryColor,
      accentColor: entity.accentColor,
      logoUrl: entity.logoUrl,
      bannerUrls: entity.bannerUrls,
      createdAt: entity.createdAt,
    );
  }

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      primaryColor: Color(json['primaryColor'] as int),
      accentColor: Color(json['accentColor'] as int),
      logoUrl: json['logoUrl'] as String,
      bannerUrls: List<String>.from(json['bannerUrls'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryColor': primaryColor.value,
      'accentColor': accentColor.value,
      'logoUrl': logoUrl,
      'bannerUrls': bannerUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
