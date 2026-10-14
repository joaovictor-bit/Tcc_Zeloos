import 'dart:math';
import '../data/mock_data.dart';
import '../models/models.dart';

// ===== AUTENTICAÇÃO =====
// TODO(integração): trocar por FirebaseAuth / API (JWT). Autorização: validar no backend
// que o responsável só acessa crianças com responsibleId == user.id.
abstract class AuthService {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String phone, String password);
  Future<void> resetPassword(String email);
}

class MockAuthService implements AuthService {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return MockData.user;
  }
  @override
  Future<User> register(String name, String email, String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return User(id: 'u1', name: name, email: email, phone: phone, createdAt: DateTime.now());
  }
  @override
  Future<void> resetPassword(String email) async =>
      Future.delayed(const Duration(milliseconds: 600));
}

// ===== LOCALIZAÇÃO =====
// TODO(integração): GPS real (geolocator) no aparelho da criança, com consentimento e
// permissões claras; backend recebe e o responsável consome via stream (Firestore/WebSocket).
// Geofencing: usar geofencing nativo/servidor com as SafeZones.
abstract class LocationService {
  Future<Location> fetchLatest(Location previous);
  Future<List<LocationHistory>> history(String childId, DateTime day);
}

class MockLocationService implements LocationService {
  final _r = Random();
  @override
  Future<Location> fetchLatest(Location p) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return Location(id: 'l${_r.nextInt(99999)}', childId: p.childId,
        latitude: p.latitude + (_r.nextDouble() - .5) * .0008,
        longitude: p.longitude + (_r.nextDouble() - .5) * .0008, timestamp: DateTime.now());
  }
  @override
  Future<List<LocationHistory>> history(String childId, DateTime day) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO(integração): buscar histórico por criança/dia; desenhar trajeto (polyline) no mapa.
    final base = MockData.locations[childId] ??
        Location(id: 'x', childId: childId, latitude: MockData.baseLat,
            longitude: MockData.baseLng, timestamp: day);
    return List.generate(6, (i) => LocationHistory(
        id: 'h$i$childId', childId: childId,
        latitude: base.latitude - i * .0005, longitude: base.longitude - i * .0004,
        timestamp: DateTime(day.year, day.month, day.day, 8 + i * 2, 15 * (i % 4)),
        address: MockData.addresses[i % MockData.addresses.length]));
  }
}
