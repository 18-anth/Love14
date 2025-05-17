import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppStyles {
  static TextStyle titleStyle(BuildContext context) {
    return GoogleFonts.greatVibes(
      fontSize: 32,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle poemTitleStyle(BuildContext context) {
    return GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle poemContentStyle(BuildContext context) {
    return GoogleFonts.lora(
      fontSize: 18,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle authorStyle(BuildContext context) {
    return GoogleFonts.lora(
      fontSize: 14,
      fontStyle: FontStyle.italic,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
    );
  }
}
