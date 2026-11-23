import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF1C3A70),
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.white70,
      currentIndex: currentIndex,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
        BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Permisos'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Avisos'),
        BottomNavigationBarItem(icon: Icon(Icons.badge_outlined), label: 'Perfil'),
      ],
      onTap: (index) {},
    );
  }
}