import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

// TODO(integração): registrar as SafeZones em um serviço de geofencing (nativo ou servidor)
// e gerar Alerts ao entrar/sair. Escolher a posição tocando no mapa real.
class SafeZonesScreen extends StatelessWidget {
  const SafeZonesScreen({super.key});

  Future<void> _edit(BuildContext context, {SafeZone? zone}) async {
    final c = AppController.I;
    final form = GlobalKey<FormState>();
    final name = TextEditingController(text: zone?.name);
    final lat = TextEditingController(text: (zone?.latitude ?? MockData.baseLat).toString());
    final lng = TextEditingController(text: (zone?.longitude ?? MockData.baseLng).toString());
    var radius = zone?.radius ?? 150;
    var childId = zone?.childId ?? c.children.first.id;
    await showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(builder: (ctx, set) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Form(key: form, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(zone == null ? 'Nova área segura' : 'Editar área', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
              value: childId, decoration: const InputDecoration(labelText: 'Criança'),
              items: [for (final ch in c.children) DropdownMenuItem(value: ch.id, child: Text(ch.name))],
              onChanged: (v) => set(() => childId = v!)),
          const SizedBox(height: 12),
          ZField(controller: name, label: 'Nome (Casa, Escola...)', icon: Icons.place_outlined, validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: ZField(controller: lat, label: 'Latitude', icon: Icons.north, keyboard: const TextInputType.numberWithOptions(signed: true, decimal: true), validator: (v) => double.tryParse(v ?? '') == null ? 'Inválido' : null)),
            const SizedBox(width: 8),
            Expanded(child: ZField(controller: lng, label: 'Longitude', icon: Icons.east, keyboard: const TextInputType.numberWithOptions(signed: true, decimal: true), validator: (v) => double.tryParse(v ?? '') == null ? 'Inválido' : null)),
          ]),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: Text('Raio: ${radius.round()} m')),
          Slider(value: radius, min: 50, max: 500, divisions: 45, onChanged: (v) => set(() => radius = v)),
          const SizedBox(height: 8),
          ZButton('Salvar', onPressed: () {
            if (!form.currentState!.validate()) return;
            c.saveZone(SafeZone(id: zone?.id ?? 'z${DateTime.now().millisecondsSinceEpoch}', childId: childId,
                name: name.text.trim(), latitude: double.parse(lat.text), longitude: double.parse(lng.text),
                radius: radius, createdAt: zone?.createdAt ?? DateTime.now()));
            Navigator.pop(ctx);
            showSnack(context, 'Área segura salva');
          }),
        ]))),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) => Scaffold(
        appBar: zAppBar('Áreas seguras'),
        floatingActionButton: FloatingActionButton.extended(onPressed: () => _edit(context), icon: const Icon(Icons.add), label: const Text('Nova área')),
        body: c.zones.isEmpty
            ? const EmptyState(Icons.shield_moon_outlined, 'Nenhuma área segura criada.')
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90), itemCount: c.zones.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final z = c.zones[i];
                  return Card(child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0x1F1E9E5A), child: Icon(Icons.shield, color: AppTheme.success)),
                    title: Text(z.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${c.childById(z.childId)?.name ?? ''} • raio ${z.radius.round()} m'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _edit(context, zone: z)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: AppTheme.danger), onPressed: () async {
                        if (await confirm(context, 'Excluir área?', 'A área "${z.name}" será removida.', ok: 'Excluir')) {
                          c.deleteZone(z.id);
                          if (context.mounted) showSnack(context, 'Área excluída');
                        }
                      }),
                    ]),
                  ));
                }),
      ),
    );
  }
}
