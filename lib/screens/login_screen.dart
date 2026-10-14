import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/widgets.dart';
import 'main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'joao@zeloos.app');
  final _pass = TextEditingController(text: '123456');
  bool _loading = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AppController.I.login(_email.text.trim(), _pass.text);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
    } catch (_) {
      if (mounted) showSnack(context, 'Não foi possível entrar. Tente novamente.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgot() async {
    if (Validators.email(_email.text) != null) return showSnack(context, 'Informe um e-mail válido acima.', error: true);
    await AppController.I.auth.resetPassword(_email.text.trim()); // TODO(integração): e-mail real de recuperação
    if (mounted) showSnack(context, 'Se o e-mail existir, enviaremos instruções.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _form,
                  child: Column(children: [
                    const Icon(Icons.shield_outlined, size: 64, color: AppTheme.navy),
                    const Text('ZELOOS', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 3, color: AppTheme.navy)),
                    const SizedBox(height: 32),
                    ZField(controller: _email, label: 'E-mail', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress, validator: Validators.email),
                    const SizedBox(height: 14),
                    ZField(controller: _pass, label: 'Senha', icon: Icons.lock_outline, obscure: true, validator: Validators.password),
                    Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _forgot, child: const Text('Esqueci minha senha'))),
                    const SizedBox(height: 8),
                    ZButton('Entrar', onPressed: _submit, loading: _loading),
                    const SizedBox(height: 12),
                    ZButton('Criar conta', outlined: true, onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()))),
                  ]),
                ),
              ),
            ),
          ),
        ),
      );
}
