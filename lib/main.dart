import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fx_flame/router/app_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'common/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();
  final packageName = packageInfo.packageName;

  // You can use packageName to differentiate between flavors if needed
  debugPrint('Running package: $packageName');

  // For now, initializing Firebase with default options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  theme.initialize();

  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    routerConfig: appRouter.router,
    theme: theme.adaptiveTheme,
    darkTheme: theme.adaptiveTheme,
    themeMode: ThemeMode.system,
  ));
}
