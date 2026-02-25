import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fx_flame/router/app_router.dart';

import 'common/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
