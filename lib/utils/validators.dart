class Validators {
  static String? required(String? v, [String label = 'Campo']) =>
      (v == null || v.trim().isEmpty) ? '$label é obrigatório' : null;
  static String? email(String? v) {
    if (required(v, 'E-mail') != null) return 'E-mail é obrigatório';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v!.trim()) ? null : 'E-mail inválido';
  }
  static String? password(String? v) =>
      (v == null || v.length < 6) ? 'Mínimo de 6 caracteres' : null;
  static String? phone(String? v) {
    final d = (v ?? '').replaceAll(RegExp(r'\D'), '');
    return d.length >= 10 ? null : 'Telefone inválido';
  }
  static String fmtTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  static String fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  static String ago(DateTime d) {
    final m = DateTime.now().difference(d).inMinutes;
    if (m < 1) return 'agora';
    if (m < 60) return 'há $m min';
    return 'há ${m ~/ 60} h';
  }
}
