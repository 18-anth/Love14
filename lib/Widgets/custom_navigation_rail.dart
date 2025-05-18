import 'package:flutter/material.dart';
import 'package:love14/Utils/app_colors.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      labelType: NavigationRailLabelType.all,
      backgroundColor: AppColors.cream,
      selectedIconTheme: const IconThemeData(color: AppColors.primaryYellow),
      unselectedIconTheme: const IconThemeData(color: Colors.grey),
      destinations: [
        // Inicio (conservado como pediste)
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Inicio'),
        ),

        // Favoritos (conservado como pediste)
        NavigationRailDestination(
          icon: Icon(Icons.favorite_outlined),
          selectedIcon: Icon(Icons.favorite),
          label: Text('Favoritos'),
        ),

        // Primer apartado - Flores amarillas
        NavigationRailDestination(
          icon: _buildFlowerIcon(false),
          selectedIcon: _buildFlowerIcon(true),
          label: const Text('Flores'),
        ),

        // Segundo apartado - Animaciones
        NavigationRailDestination(
          icon: Icon(Icons.animation_outlined),
          selectedIcon: Icon(Icons.animation, color: AppColors.primaryYellow),
          label: const Text('Momentos'),
        ),

        // Tercer apartado - Historia de amor
        NavigationRailDestination(
          icon: Icon(Icons.person),
          selectedIcon: Icon(Icons.person_3_outlined, color: Colors.red),
          label: const Text('Perfil'),
        ),
      ],
    );
  }

  Widget _buildFlowerIcon(bool isSelected) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.local_florist_outlined,
          color: isSelected ? AppColors.primaryYellow : Colors.grey,
        ),
        if (isSelected)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class ScrollingAnimationsScreen extends StatelessWidget {
  const ScrollingAnimationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Text(
                'Momento ${index + 1}',
                style: TextStyle(color: Colors.grey[600], fontSize: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoveStoryScreen extends StatelessWidget {
  const LoveStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(
              "Te amo",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Porque eres la persona más maravillosa que ha entrado en mi vida...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
