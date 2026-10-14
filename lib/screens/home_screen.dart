import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import 'history_screen.dart';
import 'safe_zones_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) {
        final recent = c.alerts.take(3).toList();
        return Scaffold(
          appBar: zAppBar('ZELOOS'),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            Text('Olá, ${c.user?.name.split(' ').first ?? ''}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.navy)),
            const SectionTitle('Suas crianças'),
            if (c.children.isEmpty) const SizedBox(height: 160, child: EmptyState(Icons.child_care, 'Nenhuma criança cadastrada ainda.')),
            for (final ch in c.children) ...[
              ChildCard(child: ch, lastUpdate: c.latest[ch.id]?.timestamp, onTap: () => c.showChildOnMap(ch.id)),
              const SizedBox(height: 12),
            ],
            const SectionTitle('Acesso rápido'),
            Row(children: [
              _Quick(Icons.map, 'Mapa', () => c.setTab(1)),
              _Quick(Icons.shield_moon_outlined, 'Áreas seguras', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafeZonesScreen()))),
              _Quick(Icons.history, 'Histórico', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
            ]),
            const SectionTitle('Alertas recentes'),
            if (recent.isEmpty) const EmptyState(Icons.notifications_none, 'Sem alertas por aqui.'),
            for (final a in recent) Padding(padding: const EdgeInsets.only(bottom: 8), child: AlertCard(a, onTap: () => c.setTab(3))),
          ]),
        );
      },
    );
  }
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Quick(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16), onTap: onTap,
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Column(children: [
                Icon(icon, color: AppTheme.navy), const SizedBox(height: 6),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
              ])),
            ),
          ),
        ),
      );
}
