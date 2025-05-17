import 'package:flutter/material.dart';
import 'package:love14/utils/app_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: AppStyles.titleStyle(context),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pantalla de notificaciones'),
      ),
    );
  }
}