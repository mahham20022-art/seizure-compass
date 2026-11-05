import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'core/theme/app_theme.dart';

class SeizureCompassApp extends StatelessWidget {
  const SeizureCompassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seizure Compass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onGenerateInitialRoutes: AppRoutes.initialRoutes,
    );
  }
}
