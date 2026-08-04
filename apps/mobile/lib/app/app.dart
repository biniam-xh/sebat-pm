import 'package:flutter/material.dart';

import 'package:sebatpm/app/router.dart';
import 'package:sebatpm/app/theme.dart';

/// App bootstrap: theme + routing stubs.
class SebatPmApp extends StatelessWidget {
  const SebatPmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SebatPM',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
