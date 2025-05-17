import 'package:flutter/material.dart';
import 'package:love14/utils/app_colors.dart';

class RomanticButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;

  const RomanticButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: color ?? AppColors.primaryPink,
      splashRadius: 20,
      iconSize: 24,
    );
  }
}