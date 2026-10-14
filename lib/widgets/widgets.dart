import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';

void showSnack(BuildContext c, String msg, {bool error = false}) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: error ? AppTheme.danger : AppTheme.navy));
}

Future<bool> confirm(BuildContext c, String title, String msg, {String ok = 'Confirmar'}) async {
  final r = await showDialog<bool>(
    context: c,
    builder: (_) => AlertDialog(title: Text(title), content: Text(msg), actions: [
      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancelar')),
      FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(ok)),
    ]),
  );
  return r ?? false;
}

class ZButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading, outlined;
  final IconData? icon;
  const ZButton(this.label, {super.key, this.onPressed, this.loading = false, this.outlined = false, this.icon});
  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ]);
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    return SizedBox(
      width: double.infinity, height: 52,
      child: outlined
          ? OutlinedButton(onPressed: onPressed, style: OutlinedButton.styleFrom(shape: shape), child: child)
          : FilledButton(onPressed: loading ? null : onPressed, style: FilledButton.styleFrom(shape: shape), child: child),
    );
  }
}

class ZField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final bool obscure, readOnly;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  const ZField({super.key, this.controller, required this.label, required this.icon, this.obscure = false,
      this.readOnly = false, this.keyboard, this.validator, this.onTap});
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller, obscureText: obscure, keyboardType: keyboard, validator: validator,
        readOnly: readOnly, onTap: onTap,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      );
}

class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  const StatusChip(this.text, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      );
}

class ChildAvatar extends StatelessWidget {
  final Child child;
  final double radius;
  const ChildAvatar(this.child, {super.key, this.radius = 26});
  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: radius, backgroundColor: AppTheme.navy.withOpacity(.1),
        // TODO(integração): exibir child.photoUrl (NetworkImage) quando houver storage.
        child: Text(child.name[0], style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.bold, fontSize: radius * .8)),
      );
}

class ChildCard extends StatelessWidget {
  final Child child;
  final DateTime? lastUpdate;
  final VoidCallback onTap;
  final String buttonLabel;
  const ChildCard({super.key, required this.child, this.lastUpdate, required this.onTap, this.buttonLabel = 'Ver localização'});
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ChildAvatar(child),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(child.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${child.age} anos', style: const TextStyle(color: Colors.black54)),
              ])),
              child.locationEnabled
                  ? const StatusChip('Localização ativa', AppTheme.success)
                  : const StatusChip('Pausada', AppTheme.warning),
            ]),
            const SizedBox(height: 10),
            Text('Última atualização: ${lastUpdate == null ? '—' : Validators.ago(lastUpdate!)}',
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: FilledButton.tonalIcon(
                onPressed: onTap, icon: const Icon(Icons.location_on_outlined), label: Text(buttonLabel))),
          ]),
        ),
      );
}

class AlertStyle {
  static IconData icon(AlertType t) => switch (t) {
        AlertType.leftSafeZone => Icons.logout,
        AlertType.enteredSafeZone => Icons.login,
        AlertType.locationUnavailable => Icons.location_off,
        AlertType.lowBattery => Icons.battery_alert,
        AlertType.deviceDisconnected => Icons.portable_wifi_off,
      };
  static Color color(AlertPriority p) => switch (p) {
        AlertPriority.high => AppTheme.danger,
        AlertPriority.medium => AppTheme.warning,
        AlertPriority.low => AppTheme.success,
      };
  static String label(AlertPriority p) => switch (p) {
        AlertPriority.high => 'Alta',
        AlertPriority.medium => 'Média',
        AlertPriority.low => 'Baixa',
      };
}

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback? onTap;
  const AlertCard(this.alert, {super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = AlertStyle.color(alert.priority);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: c.withOpacity(.12), child: Icon(AlertStyle.icon(alert.type), color: c)),
        title: Text(alert.title, style: TextStyle(fontWeight: alert.read ? FontWeight.normal : FontWeight.bold)),
        subtitle: Text('${alert.message}\n${Validators.ago(alert.timestamp)}'),
        isThreeLine: true,
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          StatusChip(AlertStyle.label(alert.priority), c),
          if (!alert.read) const Padding(padding: EdgeInsets.only(top: 4), child: CircleAvatar(radius: 4, backgroundColor: AppTheme.navy)),
        ]),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const EmptyState(this.icon, this.text, {super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56, color: Colors.black26),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
        ])),
      );
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorState(this.message, this.onRetry, {super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.danger),
          const SizedBox(height: 8),
          Text(message),
          TextButton(onPressed: onRetry, child: const Text('Tentar novamente')),
        ]),
      );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navy)),
      );
}

PreferredSizeWidget zAppBar(String title, {List<Widget>? actions}) =>
    AppBar(title: Text(title), actions: actions);
