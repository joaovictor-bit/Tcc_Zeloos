import '../models/models.dart';

// DADOS FICTÍCIOS apenas para demonstração. Nenhum dado real.
class MockData {
  static final now = DateTime.now();
  static const baseLat = -23.5505, baseLng = -46.6333; // ponto fictício
  static final user = User(id: 'u1', name: 'João Silva', email: 'joao@zeloos.app',
      phone: '(11) 90000-0000', createdAt: DateTime(2026, 1, 10));
  static final children = [
    Child(id: 'c1', name: 'Lucas Silva', birthDate: DateTime(2016, 4, 12), responsibleId: 'u1',
        deviceId: 'DEV-1001', createdAt: DateTime(2026, 1, 12)),
    Child(id: 'c2', name: 'Sofia Silva', birthDate: DateTime(2019, 8, 3), responsibleId: 'u1',
        deviceId: 'DEV-1002', createdAt: DateTime(2026, 1, 12)),
  ];
  static final locations = {
    'c1': Location(id: 'l1', childId: 'c1', latitude: baseLat + 0.004, longitude: baseLng + 0.003,
        timestamp: now.subtract(const Duration(minutes: 1))),
    'c2': Location(id: 'l2', childId: 'c2', latitude: baseLat - 0.003, longitude: baseLng - 0.004,
        timestamp: now.subtract(const Duration(minutes: 7))),
  };
  static final alerts = [
    Alert(id: 'a1', childId: 'c1', type: AlertType.leftSafeZone, title: 'Saiu de área segura',
        message: 'Lucas saiu de "Escola".', timestamp: now.subtract(const Duration(minutes: 12))),
    Alert(id: 'a2', childId: 'c2', type: AlertType.lowBattery, title: 'Bateria baixa',
        message: 'Dispositivo da Sofia está com 12%.', timestamp: now.subtract(const Duration(minutes: 40))),
    Alert(id: 'a3', childId: 'c1', type: AlertType.enteredSafeZone, title: 'Entrou em área segura',
        message: 'Lucas chegou em "Casa".', timestamp: now.subtract(const Duration(hours: 3)), read: true),
    Alert(id: 'a4', childId: 'c2', type: AlertType.locationUnavailable, title: 'Localização indisponível',
        message: 'Sem sinal de GPS da Sofia.', timestamp: now.subtract(const Duration(hours: 5)), read: true),
  ];
  static final zones = [
    SafeZone(id: 'z1', childId: 'c1', name: 'Casa', latitude: baseLat, longitude: baseLng,
        radius: 150, createdAt: DateTime(2026, 1, 15)),
    SafeZone(id: 'z2', childId: 'c1', name: 'Escola', latitude: baseLat + 0.004, longitude: baseLng + 0.003,
        radius: 200, createdAt: DateTime(2026, 1, 15)),
    SafeZone(id: 'z3', childId: 'c2', name: 'Casa dos avós', latitude: baseLat - 0.003,
        longitude: baseLng - 0.004, radius: 120, createdAt: DateTime(2026, 2, 1)),
  ];
  static const addresses = ['Rua das Flores, 120', 'Av. Central, 800', 'Praça da Escola, 15',
      'Rua do Comércio, 42', 'Av. Principal, 1000', 'Rua Nova, 7'];
}
