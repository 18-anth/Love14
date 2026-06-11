// Rutas para Surprises Feature
// Agregar estas rutas al archivo lib/Router/routes.dart

import 'package:flutter/material.dart';
import 'package:love14/Screens/my_surprises_screen.dart';
import 'package:love14/Screens/create_surprise_screen.dart';
import 'package:love14/Screens/surprise_view_screen.dart';

// Ejemplo de cómo agregar a routes.dart:
/*
final Map<String, WidgetBuilder> routes = {
  // ... existing routes ...
  
  // Surprises routes
  '/surprises': (context) => MySurprisesScreen(
    userUid: FirebaseAuth.instance.currentUser!.uid,
    userName: 'User Name',
  ),
  '/create-surprise': (context) => CreateSurpriseScreen(
    userUid: FirebaseAuth.instance.currentUser!.uid,
    userName: 'User Name',
  ),
  '/surprise/:id': (context) {
    final settings = context as RouteSettings;
    final id = settings.arguments as String?;
    return SurpriseViewScreen(surpriseId: id ?? '');
  },
};
*/

// Para usar en el main.dart, agregar a MultiProvider:
/*
ChangeNotifierProvider(
  create: (_) => SurpriseProvider(),
),
*/
