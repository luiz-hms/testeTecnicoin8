import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppTheme extends Equatable {
  final String id;
  final String name;
  final Color primaryColor;
  final Color accentColor;
  final String logoUrl;
  final List<String> bannerUrls;
  final DateTime createdAt;

  const AppTheme({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.accentColor,
    required this.logoUrl,
    required this.bannerUrls,
    required this.createdAt,
  });

  AppTheme copyWith({
    String? id,
    String? name,
    Color? primaryColor,
    Color? accentColor,
    String? logoUrl,
    List<String>? bannerUrls,
    DateTime? createdAt,
  }) {
    return AppTheme(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrls: bannerUrls ?? this.bannerUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    primaryColor,
    accentColor,
    logoUrl,
    bannerUrls,
    createdAt,
  ];
}

/// Tema padrão da aplicação
final defaultTheme = AppTheme(
  id: 'default_theme',
  name: 'DevNology Default',
  primaryColor: const Color(0xFF1976D2),
  accentColor: const Color(0xFFFF6D00),
  logoUrl:
      'https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg',
  bannerUrls: const [
    'https://picsum.photos/seed/banner1/1200/500',
    'https://picsum.photos/seed/banner2/1200/500',
    'https://picsum.photos/seed/banner3/1200/500',
    'https://picsum.photos/seed/banner4/1200/500',
  ],
  createdAt: DateTime(2024, 1, 1),
);
