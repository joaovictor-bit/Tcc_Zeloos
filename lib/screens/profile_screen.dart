import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) {
        final u = c.user;
        if (u == null) return const SizedBox();
        return Scaffold(
          appBar: zAppBar('Perfil'),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            Center(child: CircleAvatar(radius: 44, backgroundColor: AppTheme.navy,
                child: Text(u.name[0], style: const TextStyle(fontSize: 34, color: Colors.white)))),
            const SizedBox(height: 12),
            Center(child: Text(u.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            Card(child: Column(children: [
              ListTile(leading: const Icon(Icons.email_outlined), title: const Text('E-mail'), subtitle: Text(u.email)),
              ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('Telefone'), subtitle: Text(u.phone)),
            ])),
            const SectionTitle('Configurações'),
            Card(child: Column(children: [
              SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined), title: const Text('Notificações'),
                  value: c.notificationsOn, // TODO(integração): solicitar permissão de notificações (FCM)
                  onChanged: (v) { c.notificationsOn = v; c.refreshUi(); }),
              SwitchListTile(
                  secondary: const Icon(Icons.location_searching), title: const Text('Localização em segundo plano'),
                  subtitle: const Text('Solicitada de forma clara ao usuário, quando apropriado'),
                  value: c.backgroundLocationOn, // TODO(integração): permission_handler
                  onChanged: (v) { c.backgroundLocationOn = v; c.refreshUi(); }),
              ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Privacidade'),
                  subtitle: const Text('Só responsáveis autorizados veem a localização'),
                  onTap: () => showSnack(context, 'Política de privacidade (em breve)')),
            ])),
            const SizedBox(height: 20),
            ZButton('Sair da conta', outlined: true, icon: Icons.logout, onPressed: () async {
              if (await confirm(context, 'Sair da conta?', 'Você precisará entrar novamente.', ok: 'Sair')) {
                c.logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                }
              }
            }),
          ]),
        );
      },
    );
  }
}
