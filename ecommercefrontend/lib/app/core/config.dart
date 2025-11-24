import 'package:ecommercefrontend/app/core/helpers/environments.dart';
import 'package:flutter/cupertino.dart';

class Config {
  Future<void> configApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    _loadEnvs();
  }

  Future<void> _loadEnvs() => Environments.loadEnvs();
}
