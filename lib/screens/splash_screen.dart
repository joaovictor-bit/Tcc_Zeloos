import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      // TODO(integração): checar sessão persistida (token/Firebase currentUser).
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => AppController.I.loggedIn ? const MainShell() : const LoginScreen()));
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppTheme.navy,
        body: Center(
          child: FadeTransition(
            opacity: _c,
            child: ScaleTransition(
              scale: Tween(begin: .8, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack)),
              child: const Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.shield_outlined, size: 84, color: Colors.white),
                SizedBox(height: 16),
                Text('ZELOOS', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: 4)),
                SizedBox(height: 6),
                Text('Proteção e tranquilidade', style: TextStyle(color: Colors.white70)),
              ]),
            ),
          ),
        ),
      );
}
