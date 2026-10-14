import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../utils/validators.dart';
import '../widgets/widgets.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(), _email = TextEditingController(),
      _phone = TextEditingController(), _pass = TextEditingController(), _pass2 = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AppController.I.register(_name.text.trim(), _email.text.trim(), _phone.text.trim(), _pass.text);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
    } catch (_) {
      if (mounted) showSnack(context, 'Erro ao criar conta.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: zAppBar('Criar conta'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _form,
            child: Column(children: [
              ZField(controller: _name, label: 'Nome', icon: Icons.person_outline, validator: (v) => Validators.required(v, 'Nome')),
              const SizedBox(height: 14),
              ZField(controller: _email, label: 'E-mail', icon: Icons.email_outlined, keyboard: TextInputType.emailAddress, validator: Validators.email),
              const SizedBox(height: 14),
              ZField(controller: _phone, label: 'Telefone', icon: Icons.phone_outlined, keyboard: TextInputType.phone, validator: Validators.phone),
              const SizedBox(height: 14),
              ZField(controller: _pass, label: 'Senha', icon: Icons.lock_outline, obscure: true, validator: Validators.password),
              const SizedBox(height: 14),
              ZField(controller: _pass2, label: 'Confirmar senha', icon: Icons.lock_outline, obscure: true,
                  validator: (v) => v != _pass.text ? 'As senhas não coincidem' : null),
              const SizedBox(height: 24),
              ZButton('Criar conta', onPressed: _submit, loading: _loading),
            ]),
          ),
        ),
      );
}
