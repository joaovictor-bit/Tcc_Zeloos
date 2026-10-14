import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import 'alerts_screen.dart';
import 'children_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});
  @override
  Widget build(BuildContext context) {
    final c = AppController.I;
    return ListenableBuilder(
      listenable: c,
      builder: (_, __) => Scaffold(
        body: IndexedStack(index: c.tab, children: const [
          HomeScreen(), MapScreen(), ChildrenScreen(), AlertsScreen(), ProfileScreen(),
        ]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: c.tab,
          onDestinationSelected: c.setTab,
          destinations: [
            const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
            const NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Mapa'),
            const NavigationDestination(icon: Icon(Icons.child_care_outlined), selectedIcon: Icon(Icons.child_care), label: 'Crianças'),
            NavigationDestination(
                icon: Badge(isLabelVisible: c.unreadAlerts > 0, label: Text('${c.unreadAlerts}'), child: const Icon(Icons.notifications_outlined)),
                selectedIcon: const Icon(Icons.notifications), label: 'Alertas'),
            const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
