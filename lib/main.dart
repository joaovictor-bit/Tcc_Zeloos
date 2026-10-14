import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ZeloosApp());

class ZeloosApp extends StatelessWidget {
  const ZeloosApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ZELOOS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      );
}
