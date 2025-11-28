import 'package:ecommercefrontend/app/core/config.dart';
import 'package:ecommercefrontend/my_app.dart';
import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';
import 'package:ecommercefrontend/app/core/services/whitelabel_init_service.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/white_label_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  await Config().configApp();
  usePathUrlStrategy();
  await WhiteLabelData.initialize();
  await setupServiceLocator();

  // Inicializar configurações whitelabel da API
  try {
    final whitelabelService = getIt<WhitelabelInitService>();
    await whitelabelService.initializeFromUrl();
  } catch (e) {
    print('⚠️ Whitelabel não inicializado: $e');
  }

  runApp(const MyApp());
}
