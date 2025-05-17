// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:love14/Widgets/Flower3DScreen.dart';
import 'package:love14/Widgets/Margarita_flower.dart';
import 'package:love14/Widgets/Tulipan_flower.dart';
import 'package:love14/utils/app_styles.dart';

class Flowers extends StatefulWidget {
  const Flowers({super.key});

  @override
  State<Flowers> createState() => _FlowersState();
}

class _FlowersState extends State<Flowers> {
  // Índice de pantalla actual
  int _currentPageIndex = 0;

  // Lista de pantallas a mostrar
  final List<Widget> _pages = [
    Flower3DScreen(),
    Margarita3DScreen(),
    TulipanScreen(),
  ];

  void _nextPage() {
    setState(() {
      if (_currentPageIndex < _pages.length - 1) {
        _currentPageIndex++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi Corazón es un Jardín",
          style: AppStyles.titleStyle(context),
        ),
        centerTitle: true,
      ),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _currentPageIndex == 0 ? null : _previousPage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors
                        .grey
                        .shade300; // Color cuando está deshabilitado
                  }
                  return Colors
                      .amber
                      .shade700; // Color amarillo fuerte cuando está habilitado
                }),
                foregroundColor: MaterialStateProperty.all(
                  Colors.black,
                ), // Color del texto
              ),
              child: const Text('Atrás'),
            ),
            ElevatedButton(
              onPressed:
                  _currentPageIndex == _pages.length - 1 ? null : _nextPage,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey.shade300;
                  }
                  return Colors.amber.shade700;
                }),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
