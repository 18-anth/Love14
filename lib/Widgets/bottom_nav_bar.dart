import 'package:flutter/material.dart';
import 'package:love14/utils/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.pink,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.cream,
      items: [
        // Inicio (conservado)
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),

        // Favoritos (conservado)
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outlined),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),

        // Nuestras Flores
        BottomNavigationBarItem(
          icon: _buildFlowerIcon(false),
          activeIcon: _buildFlowerIcon(true),
          label: 'Flores',
        ),

        // Nuestros Momentos
        const BottomNavigationBarItem(
          icon: Icon(Icons.animation_outlined),
          activeIcon: Icon(Icons.animation),
          label: 'Momentos',
        ),

        // Sorpresas
        const BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard_outlined),
          activeIcon: Icon(Icons.card_giftcard),
          label: 'Sorpresas',
        ),

        // Nuestra Historia
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          activeIcon: Icon(Icons.person_3_outlined, color: Colors.pink),
          label: 'Perfil',
        ),
      ],
    );
  }

  Widget _buildFlowerIcon(bool isActive) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.local_florist_outlined,
          color: isActive ? AppColors.darkBackground : Colors.grey,
        ),
        if (isActive)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
