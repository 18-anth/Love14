import 'dart:math';
import 'package:flutter/material.dart';

class YellowFlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Dibujar fondo blanco
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Dibujar capas de pétalos
    _drawPetalLayer(canvas, center, 100, 40, 16, 0);
    _drawPetalLayer(canvas, center, 80, 30, 12, pi / 12);

    // Centro de la flor con textura
    _drawFlowerCenter(canvas, center);
  }

  void _drawPetalLayer(Canvas canvas, Offset center, double radius, double petalLength, int count, double rotation) {
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi / count) * i + rotation;
      final petalCenter = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      _drawPetal(canvas, petalCenter, angle);
    }
  }

  void _drawPetal(Canvas canvas, Offset center, double angle) {
    final path = Path();

    // Forma curva del pétalo
    path.moveTo(center.dx, center.dy);
    path.quadraticBezierTo(
      center.dx + 15 * cos(angle - pi / 8),
      center.dy + 15 * sin(angle - pi / 8),
      center.dx + 40 * cos(angle),
      center.dy + 40 * sin(angle),
    );
    path.quadraticBezierTo(
      center.dx + 15 * cos(angle + pi / 8),
      center.dy + 15 * sin(angle + pi / 8),
      center.dx,
      center.dy,
    );

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade700],
        center: Alignment.center,
        radius: 0.6,
      ).createShader(Rect.fromCircle(center: center, radius: 40))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Sombra sutil
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path.shift(const Offset(2, 2)), shadowPaint);
  }

  void _drawFlowerCenter(Canvas canvas, Offset center) {
    final Paint centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.brown.shade800, Colors.black],
        center: Alignment.center,
        radius: 0.8,
      ).createShader(Rect.fromCircle(center: center, radius: 25))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, centerPaint);

    // Semillas (textura)
    final seedPaint = Paint()..color = Colors.black.withOpacity(0.2);
    for (int i = 0; i < 100; i++) {
      final angle = 2 * pi * i / 100;
      final r = sqrt(i) * 2.5;
      final offset = Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      );
      canvas.drawCircle(offset, 1.5, seedPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class YellowFlowerWidget extends StatelessWidget {
  const YellowFlowerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: YellowFlowerPainter(),
      child: const SizedBox.expand(),
    );
  }
}
