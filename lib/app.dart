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
      // Big monitors are read from further away: lift text slightly there,
      // on top of whatever text size the user has chosen. Phones and tablets are unchanged.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        if (mq.size.width < 1500) return child!;
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(mq.textScaler.scale(1.0) * 1.08)),
          child: child!,
        );
      },
    );
  }
}
