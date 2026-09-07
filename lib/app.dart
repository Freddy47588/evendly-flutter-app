import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'routes/app_routes.dart';
import 'features/start/start_gate.dart';

class EvendlyApp extends StatefulWidget {
  const EvendlyApp({super.key});

  @override
  State<EvendlyApp> createState() => _EvendlyAppState();
}

class _EvendlyAppState extends State<EvendlyApp> {
  @override
  void initState() {
    super.initState();
    ThemeController.instance.init(); // init sekali
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.notifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Evendly',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,

          // ✅ jangan pakai initialRoute
          home: const StartGate(),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
