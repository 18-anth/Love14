// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:love14/Client/ClientScreen.dart';
import 'package:love14/Config/LoginScreen.dart';
import 'package:love14/admin/AdminScreen.dart';
import '../Utils/app_colors.dart';

class RegisterClientScreen extends StatefulWidget {
  const RegisterClientScreen({super.key});

  @override
  _RegisterClientScreenState createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child(
    'Control/',
  );
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _redirectToRole(String email) async {
    try {
      final snapshot = await _database
          .orderByChild('email')
          .equalTo(email)
          .get();
      if (snapshot.exists) {
        final data = (snapshot.value as Map).values.first as Map;
        final role = data['role'];

        if (role == 'Client') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ClientScreen()),
          );
        } else if (role == 'Admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        } else {
          _showErrorDialog('Rol desconocido.');
        }
      } else {
        _showErrorDialog('No se encontró información para este usuario.');
      }
    } catch (e) {
      _showErrorDialog('Error al redirigir: ${e.toString()}');
    }
  }

  Future<void> _registerClient() async {
    setState(() {
      _isLoading = true;
    });

    // Validar correo electrónico
    if (!_emailController.text.trim().contains('@')) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Por favor, ingrese un correo electrónico válido.');
      return;
    }

    // Validar contraseña
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('La contraseña no puede estar vacía.');
      return;
    }

    try {
      // Crear el usuario en Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Guardar la información del Client en Firebase Realtime Database
      if (userCredential.user != null) {
        await _database.child(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'role': 'Client', // Asignando el rol
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client registrado exitosamente')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ClientScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // El correo ya está en uso, redirigir basado en el rol
        await _redirectToRole(_emailController.text.trim());
      } else {
        _showErrorDialog('Error: ${e.message}');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          56.0,
        ), // Ajusta la altura según sea necesario
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            gradient: LinearGradient(
              colors: [AppColors.goldenHour, AppColors.goldenHour],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(-10, 10),
                color: Color.fromARGB(80, 0, 0, 0),
                blurRadius: 10,
              ),
              BoxShadow(
                offset: Offset(-10, -10),
                color: Color.fromARGB(150, 255, 255, 255),
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Registrate',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.lightText,
                fontFamily: 'Playfair',
              ),
            ),
            backgroundColor:
                Colors.transparent, // Fondo transparente para usar la sombra
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.lightBackground,
          image: DecorationImage(
            image: AssetImage('assets/image/image.png'),
            opacity: 0.1,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xffe9f0f0,
                            ), // Aquí se aplica el color al borde
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(-10, 10),
                                      color: Color.fromARGB(80, 0, 0, 0),
                                      blurRadius: 10,
                                    ),
                                    BoxShadow(
                                      offset: Offset(10, -10),
                                      color: Color.fromARGB(150, 255, 255, 255),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.asset(
                                    'assets/image/image.png',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nombre',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.deepGreen,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Playfair',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppColors.goldenHour,
                                            width: 2,
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.person_3_rounded,
                                          color: AppColors.warmBrown,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Correo electrónico',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.deepGreen,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Playfair',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppColors.goldenHour,
                                            width: 2,
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          color: AppColors.warmBrown,
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 16),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Contraseña',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.deepGreen,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Playfair',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    StatefulBuilder(
                                      builder: (context, setState) {
                                        return TextField(
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: AppColors.warmBrown,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText =
                                                      !_obscureText; // Alterna la visibilidad
                                                });
                                              },
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: AppColors.goldenHour,
                                                width: 2,
                                              ),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: AppColors.warmBrown,
                                            ),
                                          ),
                                          obscureText: _obscureText,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _registerClient,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.goldenHour,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 40,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        elevation: 5,
                                        shadowColor: AppColors.warmBrown,
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            color: AppColors.lightText,
                                            size: 28,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            'Registrarse',
                                            style: TextStyle(
                                              color: AppColors.lightText,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Playfair',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          '¿Ya tienes una cuenta?',
                                          style: TextStyle(
                                            color: AppColors.deepGreen,
                                            fontFamily: 'Playfair',
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pushReplacement(
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) => const LoginScreen(),
                                                transitionsBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) {
                                                      return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                            1.0,
                                                            0.0,
                                                          ),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: child,
                                                      );
                                                    },
                                              ),
                                            );
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.local_florist,
                                                color: AppColors.warmBrown,
                                                size: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Iniciar sesión',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.warmBrown,
                                                  fontFamily: 'Playfair',
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.goldenHour),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
