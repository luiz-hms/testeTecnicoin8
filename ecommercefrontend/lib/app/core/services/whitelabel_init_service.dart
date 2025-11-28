import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:ecommercefrontend/app/domain/repositories/auth_repository.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/white_label_data.dart';
import 'package:flutter/material.dart';

/// Serviço responsável por inicializar configurações Whitelabel
/// Detecta a loja pela URL e carrega configurações da API
/// Funciona em qualquer sistema operacional sem necessidade de configuração manual
/// Suporta .localhost para resolução automática sem /etc/hosts!
class WhitelabelInitService {
  final AuthRepository _authRepository;

  WhitelabelInitService({required AuthRepository authRepository})
    : _authRepository = authRepository;

  /// Inicializa configurações whitelabel baseado na URL
  Future<void> initializeFromUrl() async {
    try {
      final storeId = await _detectStoreFromUrl();

      if (storeId == null || storeId.isEmpty) {
        return;
      }

      final storeConfig = await _authRepository.getWhitelabelStore(storeId);
      await _applyWhitelabelConfig(storeConfig);
    } catch (e) {
      print('Erro ao carregar whitelabel: $e');
    }
  }

  /// Detecta o identificador da loja a partir da URL atual
  Future<String?> _detectStoreFromUrl() async {
    try {
      final uri = Uri.base;

      final storeParam = uri.queryParameters['store'];
      if (storeParam != null && storeParam.isNotEmpty) {
        return storeParam;
      }

      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 2 && pathSegments[0] == 'store') {
        return pathSegments[1];
      }

      final hostname = uri.host;
      if (hostname.isNotEmpty &&
          hostname != 'localhost' &&
          hostname != '127.0.0.1') {
        var storeName = hostname.replaceAll('.localhost', '');

        if (storeName.contains('.')) {
          storeName = storeName.split('.').first;
        }

        return storeName;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _applyWhitelabelConfig(dynamic storeConfig) async {
    if (storeConfig.primaryColor != null) {
      final primaryColor = _parseColorFromHex(storeConfig.primaryColor!);
      await WhiteLabelData.savePrimaryColor(primaryColor.value);
    }

    if (storeConfig.secondaryColor != null) {
      final secondaryColor = _parseColorFromHex(storeConfig.secondaryColor!);
      await WhiteLabelData.saveSecondaryColor(secondaryColor.value);
    }

    if (storeConfig.logoUrl != null && storeConfig.logoUrl!.isNotEmpty) {
      final logoBytes = await _downloadImage(storeConfig.logoUrl!);
      if (logoBytes != null) {
        await WhiteLabelData.saveLogo(logoBytes);
      }
    }

    if (storeConfig.bannerImages != null &&
        storeConfig.bannerImages!.isNotEmpty) {
      final bannerBytesList = <Uint8List>[];
      for (final bannerUrl in storeConfig.bannerImages!) {
        final bannerBytes = await _downloadImage(bannerUrl);
        if (bannerBytes != null) {
          bannerBytesList.add(bannerBytes);
        }
      }
      if (bannerBytesList.isNotEmpty) {
        await WhiteLabelData.saveBanners(bannerBytesList);
      }
    }
  }

  Color _parseColorFromHex(String hexColor) {
    String hex = hexColor.replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
