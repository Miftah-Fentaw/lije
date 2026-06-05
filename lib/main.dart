import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lije/models/models.dart';
import 'package:lije/screens/screens.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENTRY POINT
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const LijeApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// ROOT APP
// ─────────────────────────────────────────────────────────────────────────────
class LijeApp extends StatelessWidget {
  const LijeApp({super.key});

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
        home: const MainShell(),
      ),
    );
  }
}
