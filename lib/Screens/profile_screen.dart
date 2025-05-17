import 'package:flutter/material.dart';
import 'package:love14/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:love14/controllers/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: AppStyles.titleStyle(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              'Usuario Poeta',
              style: AppStyles.poemTitleStyle(context),
            ),
            const SizedBox(height: 8),
            Text(
              'poeta@floresamarillas.com',
              style: AppStyles.authorStyle(context),
            ),
            const SizedBox(height: 32),
            SwitchListTile(
              title: Text(
                'Modo Oscuro',
                style: AppStyles.poemContentStyle(context),
              ),
              value: themeController.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeController.toggleTheme(value);
              },
              secondary: const Icon(Icons.dark_mode),
            ),
          ],
        ),
      ),
    );
  }
}