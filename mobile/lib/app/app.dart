import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';

class ArtepixApp extends StatelessWidget {
  const ArtepixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ARTEPIX Smart Packaging',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
