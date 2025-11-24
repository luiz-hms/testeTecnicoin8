import 'package:ecommercefrontend/app/core/config.dart';
import 'package:ecommercefrontend/app/core/my_app.dart';
import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/white_label_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  await Config().configApp();
  usePathUrlStrategy();
  await WhiteLabelData.initialize();
  await setupServiceLocator();
  runApp(const MyApp());
}
