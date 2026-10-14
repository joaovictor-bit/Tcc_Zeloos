import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../widgets/widgets.dart';
import 'add_child_screen.dart';

class ChildrenScreen extends StatelessWidget {
  const ChildrenScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) => Scaffold(
        appBar: zAppBar('Crianças'),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddChildScreen())),
          icon: const Icon(Icons.add), label: const Text('Adicionar criança')),
        body: c.children.isEmpty
            ? const EmptyState(Icons.child_care, 'Nenhuma criança vinculada.\nToque em "+ Adicionar criança".')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                itemCount: c.children.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final ch = c.children[i];
                  return ChildCard(child: ch, lastUpdate: c.latest[ch.id]?.timestamp, buttonLabel: 'Visualizar', onTap: () => c.showChildOnMap(ch.id));
                }),
      ),
    );
  }
}
