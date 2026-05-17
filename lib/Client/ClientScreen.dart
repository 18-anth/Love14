import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:love14/Config/LoginScreen.dart';
import 'package:love14/Screens/home_screen.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    final user = _auth.currentUser;
    if (user == null) {
      // Usuario no ha iniciado sesión, redirigir al login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
    // Si el usuario está autenticado, no hacemos nada, se queda en esta pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          MainNavigationScreen(), // Pantalla principal si el usuario está logueado
    );
  }
}
