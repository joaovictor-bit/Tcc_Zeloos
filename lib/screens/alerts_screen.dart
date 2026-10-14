import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../widgets/widgets.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) {
        final list = [...c.alerts]..sort((a, b) => a.read == b.read ? b.timestamp.compareTo(a.timestamp) : (a.read ? 1 : -1));
        return Scaffold(
          appBar: zAppBar('Alertas'),
          body: list.isEmpty
              ? const EmptyState(Icons.notifications_none, 'Nenhum alerta. Tudo tranquilo!')
              : ListView.separated(
                  padding: const EdgeInsets.all(16), itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => AlertCard(list[i], onTap: () => c.markAlertRead(list[i].id))),
        );
      },
    );
  }
}
