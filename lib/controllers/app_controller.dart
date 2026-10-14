import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/services.dart';

/// Estado global simples (ChangeNotifier). Pode ser trocado por Provider/Riverpod/Bloc.
class AppController extends ChangeNotifier {
  static final AppController I = AppController._();
  AppController._();

  final AuthService auth = MockAuthService();
  final LocationService locations = MockLocationService();

  User? user;
  int tab = 0;
  String? selectedChildId;
  List<Child> children = [];
  List<Alert> alerts = [];
  List<SafeZone> zones = [];
  Map<String, Location> latest = {};
  bool notificationsOn = true, backgroundLocationOn = false;

  bool get loggedIn => user != null;
  int get unreadAlerts => alerts.where((a) => !a.read).length;
  Child? childById(String id) => children.where((c) => c.id == id).firstOrNull;

  void _loadMock() {
    children = List.of(MockData.children);
    alerts = List.of(MockData.alerts);
    zones = List.of(MockData.zones);
    latest = Map.of(MockData.locations);
    selectedChildId = children.first.id;
  }

  Future<void> login(String email, String pass) async {
    user = await auth.login(email, pass);
    _loadMock();
    tab = 0;
    notifyListeners();
  }

  Future<void> register(String n, String e, String p, String pass) async {
    user = await auth.register(n, e, p, pass);
    _loadMock();
    tab = 0;
    notifyListeners();
  }

  void logout() {
    user = null;
    notifyListeners();
  }

  void refreshUi() => notifyListeners();

  void setTab(int i) {
    tab = i;
    notifyListeners();
  }

  void showChildOnMap(String id) {
    selectedChildId = id;
    tab = 1;
    notifyListeners();
  }

  Future<void> refreshLocation(String childId) async {
    final prev = latest[childId];
    if (prev == null) return;
    latest[childId] = await locations.fetchLatest(prev);
    notifyListeners();
  }

  void addChild(String name, DateTime birth, String code) {
    final id = 'c${DateTime.now().millisecondsSinceEpoch}';
    children.add(Child(id: id, name: name, birthDate: birth, responsibleId: user!.id,
        deviceId: code, createdAt: DateTime.now()));
    latest[id] = Location(id: 'l$id', childId: id, latitude: MockData.baseLat,
        longitude: MockData.baseLng, timestamp: DateTime.now());
    notifyListeners();
  }

  void markAlertRead(String id) {
    alerts = [for (final a in alerts) a.id == id ? a.copyWith(read: true) : a];
    notifyListeners();
  }

  void saveZone(SafeZone z) {
    final i = zones.indexWhere((e) => e.id == z.id);
    i >= 0 ? zones[i] = z : zones.add(z);
    notifyListeners();
  }

  void deleteZone(String id) {
    zones.removeWhere((z) => z.id == id);
    notifyListeners();
  }
}
