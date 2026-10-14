import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/widgets.dart';

/// Mapa MOCK desenhado com CustomPaint.
/// TODO(integração): substituir [_MockMap] por GoogleMap (google_maps_flutter) ou Mapbox,
/// usando os mesmos dados: latest[childId], posição do responsável e c.zones (círculos).
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _tc = TransformationController();
  bool _loading = false;

  Future<void> _refresh(String id) async {
    setState(() => _loading = true);
    await AppController.I.refreshLocation(id);
    if (mounted) {
      setState(() => _loading = false);
      showSnack(context, 'Localização atualizada');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) {
        final child = c.selectedChildId == null ? null : c.childById(c.selectedChildId!);
        final loc = child == null ? null : c.latest[child.id];
        return Scaffold(
          appBar: zAppBar('Mapa'),
          body: child == null || loc == null
              ? const EmptyState(Icons.map_outlined, 'Cadastre uma criança para ver o mapa.')
              : Column(children: [
                  SizedBox(height: 56, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8), children: [
                    for (final ch in c.children)
                      Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(
                          label: Text(ch.name.split(' ').first), selected: ch.id == child.id,
                          onSelected: (_) => c.showChildOnMap(ch.id))),
                  ])),
                  Expanded(child: Stack(children: [
                    ClipRect(child: InteractiveViewer(
                        transformationController: _tc, minScale: .6, maxScale: 4,
                        child: SizedBox.expand(child: CustomPaint(painter: _MockMap(loc, c.zones.where((z) => z.childId == child.id).toList(), child.name))))),
                    Positioned(right: 12, top: 12, child: Column(children: [
                      FloatingActionButton.small(heroTag: 'refresh', onPressed: _loading ? null : () => _refresh(child.id),
                          child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh)),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(heroTag: 'center', onPressed: () => _tc.value = Matrix4.identity(), child: const Icon(Icons.my_location)),
                    ])),
                  ])),
                  Card(
                    margin: const EdgeInsets.all(12),
                    child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                      ChildAvatar(child),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(child.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Atualizado às ${Validators.fmtTime(loc.timestamp)} (${Validators.ago(loc.timestamp)})',
                            style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      ])),
                      child.locationEnabled ? const StatusChip('Ativa', AppTheme.success) : const StatusChip('Pausada', AppTheme.warning),
                    ])),
                  ),
                ]),
        );
      },
    );
  }
}

class _MockMap extends CustomPainter {
  final Location loc;
  final List<SafeZone> zones;
  final String name;
  _MockMap(this.loc, this.zones, this.name);

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFE8EEF4));
    final grid = Paint()..color = Colors.white..strokeWidth = 6;
    for (double x = 0; x < s.width; x += 70) { canvas.drawLine(Offset(x, 0), Offset(x, s.height), grid); }
    for (double y = 0; y < s.height; y += 90) { canvas.drawLine(Offset(0, y), Offset(s.width, y), grid); }
    const scale = 40000.0; // graus -> pixels (apenas ilustrativo)
    final center = Offset(s.width / 2, s.height / 2);
    Offset pos(double lat, double lng) =>
        center + Offset((lng - loc.longitude) * scale, -(lat - loc.latitude) * scale);
    for (final z in zones) {
      final p = pos(z.latitude, z.longitude);
      canvas.drawCircle(p, z.radius * .45, Paint()..color = AppTheme.success.withOpacity(.18));
      canvas.drawCircle(p, z.radius * .45, Paint()..color = AppTheme.success..style = PaintingStyle.stroke..strokeWidth = 2);
      _text(canvas, z.name, p + const Offset(-20, -6), 11, AppTheme.success);
    }
    final me = pos(MockData.baseLat, MockData.baseLng); // TODO(integração): posição real do responsável
    canvas.drawCircle(me, 9, Paint()..color = Colors.blueAccent);
    canvas.drawCircle(me, 9, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3);
    _text(canvas, 'Você', me + const Offset(-12, 12), 11, Colors.blueAccent);
    canvas.drawCircle(center, 16, Paint()..color = AppTheme.navy);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
    _text(canvas, name, center + const Offset(-30, 22), 13, AppTheme.navy);
  }

  void _text(Canvas c, String t, Offset o, double size, Color color) {
    final tp = TextPainter(text: TextSpan(text: t, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, o);
  }

  @override
  bool shouldRepaint(covariant _MockMap old) => true;
}
