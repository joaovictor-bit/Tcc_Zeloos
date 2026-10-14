import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../models/models.dart';
import '../utils/validators.dart';
import '../widgets/widgets.dart';

// TODO(integração): desenhar o trajeto (polyline) no mapa real a partir desta lista.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final c = AppController.I;
  late String _childId = c.selectedChildId ?? c.children.first.id;
  DateTime _day = DateTime.now();
  late Future<List<LocationHistory>> _future = _load();

  Future<List<LocationHistory>> _load() => c.locations.history(_childId, _day);
  void _reload() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: zAppBar('Histórico de localização'),
        body: Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Expanded(child: DropdownButtonFormField<String>(
                value: _childId, decoration: const InputDecoration(labelText: 'Criança'),
                items: [for (final ch in c.children) DropdownMenuItem(value: ch.id, child: Text(ch.name))],
                onChanged: (v) { _childId = v!; _reload(); })),
            const SizedBox(width: 12),
            OutlinedButton.icon(
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: _day, firstDate: DateTime(2025), lastDate: DateTime.now());
                  if (d != null) { _day = d; _reload(); }
                },
                icon: const Icon(Icons.calendar_today, size: 16), label: Text(Validators.fmtDate(_day))),
          ])),
          Expanded(child: FutureBuilder<List<LocationHistory>>(
            future: _future,
            builder: (_, s) {
              if (s.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
              if (s.hasError) return ErrorState('Erro ao carregar histórico', _reload);
              final list = s.data!;
              if (list.isEmpty) return const EmptyState(Icons.history, 'Sem registros nesta data.');
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final h = list[i];
                  return Card(child: ListTile(
                    leading: CircleAvatar(child: Text(Validators.fmtTime(h.timestamp).substring(0, 2))),
                    title: Text('${Validators.fmtTime(h.timestamp)} • ${h.address}'),
                    subtitle: Text('${h.latitude.toStringAsFixed(5)}, ${h.longitude.toStringAsFixed(5)}'),
                  ));
                });
            },
          )),
        ]),
      );
}
