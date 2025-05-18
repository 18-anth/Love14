// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love14/Client/ClientScreen.dart';
import 'package:love14/Config/Register.dart';
import 'package:love14/admin/AdminScreen.dart';

import '../Utils/app_colors.dart';

//import 'package:sufa/views/ROUTER/RegisterAdmin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  Timer? _timerLOGIN;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  @override
  void dispose() {
    _timerLOGIN?.cancel(); // Cancela el timer si está activo
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ); // Validación básica de email
    return emailRegex.hasMatch(email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Correo de restablecimiento enviado. Verifica tu bandeja de entrada.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar el correo: $e')));
    }
  }

  Future<void> promptForEmailAndSendReset() async {
    String? email = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String tempEmail = '';
        return AlertDialog(
          title: const Text('Restablecer Contraseña'),
          content: TextField(
            onChanged: (value) {
              tempEmail = value;
            },
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              hintText: 'Introduce tu correo electrónico',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancelar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(tempEmail); // Confirmar
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );

    if (email != null && email.isNotEmpty) {
      await sendPasswordResetEmail(email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El correo electrónico no puede estar vacío.'),
        ),
      );
    }
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validaciones antes de intentar iniciar sesión
    if (email.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor rellena el campo Email y Contraseña.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );
      return;
    } else if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa el campo Email.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );

      return;
    } else if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor ingresa un correo electrónico válido.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );
      return;
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa el campo Contraseña.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;
      await user?.reload();

      if (user != null) {
        final DatabaseReference role = _dbRef.child('Control/').child(user.uid);
        print('Rol obtenido: $role');

        role.once().then((DatabaseEvent event) {
          if (event.snapshot.exists) {
            final value = event.snapshot.value;
            if (value != null && value is Map) {
              String? name = value['email']?.toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '¡Inicio de sesión exitoso! Bienvenido, ${name}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xfff3ece7),
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: const Color.fromARGB(255, 126, 53, 0),
                ),
              );
              _checkUserRole(user);
            } else {
              setState(() {
                errorMessage =
                    'Los datos del usuario no son válidos o no tienen el formato esperado.';
              });
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'La contraseña es incorrecta.';
        });
      } else if (e.code == 'user-not-found') {
        setState(() {
          errorMessage =
              'No se encontró un usuario con este correo electrónico.';
        });
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Las credenciales han caducado. Intenta nuevamente.';
        await _auth.signOut();
      } else {
        setState(() {
          errorMessage = 'Error al iniciar sesión, contraseña inexistente.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al iniciar sesión: $e';
      });
    }
  }

  Future<void> _checkUserRole(User user) async {
    final DatabaseReference userRef = _dbRef.child('Control/').child(user.uid);

    userRef
        .once()
        .then((DatabaseEvent event) {
          if (event.snapshot.exists) {
            final value = event.snapshot.value;

            if (value != null && value is Map) {
              String? role = value['role']?.toString();

              if (role != null) {
                if (role == 'Admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminScreen(),
                    ),
                  );
                } else if (role == 'Client') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    errorMessage = 'Rol desconocido.';
                  });
                }
              } else {
                setState(() {
                  errorMessage = 'Rol no encontrado.';
                });
              }
            } else {
              setState(() {
                errorMessage =
                    'Los datos del usuario no son válidos o no tienen el formato esperado.';
              });
            }
          } else {
            setState(() {
              errorMessage = 'Usuario no encontrado.';
            });
          }
        })
        .catchError((error) {
          setState(() {
            errorMessage = 'Error al obtener los datos del usuario: $error';
          });
        });
  }

  Future<void> _signUp() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RegisterClientScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(120),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    gradient: LinearGradient(
                      colors: [AppColors.goldenHour, AppColors.warmBrown],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepGreen.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: AppBar(
                    title: const Text(
                      'Para Mi Amor',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lightText,
                        fontFamily: 'GreatVibes',
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warmBrown.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Bienvenida Mi Vida',
                            style: TextStyle(
                              fontSize: 22,
                              color: AppColors.deepGreen,
                              fontFamily: 'Playfair',
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildEmailField(),
                          const SizedBox(height: 25),
                          _buildPasswordField(),
                          const SizedBox(height: 30),
                          _buildLoginButton(),
                          const SizedBox(height: 20),
                          _buildErrorMessage(),
                          const SizedBox(height: 25),
                          _buildSignUpRow(),
                          const SizedBox(height: 15),
                          _buildForgotPasswordButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildFlowerDecoration(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Correo Electrónico',
        labelStyle: TextStyle(
          color: AppColors.deepGreen,
          fontFamily: 'Playfair',
        ),
        prefixIcon: Icon(Icons.email, color: AppColors.warmBrown),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.goldenHour, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: _passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Contraseña',
            labelStyle: const TextStyle(
              color: AppColors.deepGreen,
              fontFamily: 'Playfair',
            ),
            prefixIcon: Icon(Icons.lock, color: AppColors.warmBrown),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.warmBrown,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.goldenHour, width: 2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _signIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.goldenHour,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: AppColors.warmBrown,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: AppColors.lightText, size: 28),
          SizedBox(width: 15),
          Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.lightText,
              fontWeight: FontWeight.bold,
              fontFamily: 'Playfair',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return AnimatedOpacity(
      opacity: errorMessage.isEmpty ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Playfair',
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿Primera vez aquí?',
          style: TextStyle(color: AppColors.deepGreen, fontFamily: 'Playfair'),
        ),
        TextButton(
          onPressed: _signUp,
          child: const Row(
            children: [
              Icon(Icons.local_florist, color: AppColors.warmBrown, size: 22),
              SizedBox(width: 5),
              Text(
                'Crear Cuenta',
                style: TextStyle(
                  color: AppColors.warmBrown,
                  fontFamily: 'Playfair',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: promptForEmailAndSendReset,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_reset, color: AppColors.warmBrown, size: 28),
          SizedBox(width: 10),
          Text(
            'Recuperar Contraseña',
            style: TextStyle(
              color: AppColors.warmBrown,
              fontSize: 16,
              fontFamily: 'Playfair',
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerDecoration() {
    return SizedBox(
      height: 200, // Ajusta según lo que desees
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/image/image.png',
              width: 120,
              opacity: const AlwaysStoppedAnimation(0.3),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/image/image.png',
              width: 100,
              opacity: const AlwaysStoppedAnimation(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
