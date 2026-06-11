import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/features/splash/ui/splash_screen.dart';
import 'package:lije/core/services/notification_service.dart';
import 'package:lije/core/l10n/strings.dart';
import 'package:lije/features/home/models/app_state.dart';
import 'package:lije/core/theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const LijeApp());
}

class LijeApp extends StatefulWidget {
  const LijeApp({super.key});

  @override
  State<LijeApp> createState() => _LijeAppState();
}

class _LijeAppState extends State<LijeApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(NotificationService.startup(appState));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLang>(
      valueListenable: langNotifier,
      builder: (context, _, __) => MaterialApp(
        title: 'Lije — Pregnancy & Child Growth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'sans-serif',
          scaffoldBackgroundColor: C.lightBlue,
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: C.darkBlue,
            onPrimary: C.white,
            surface: C.white,
            onSurface: C.darkBlue,
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}