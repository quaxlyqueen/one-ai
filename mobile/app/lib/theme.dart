import 'package:flutter/material.dart';

// TODO: Convert this to my .theme file format for cross-platform and cross-application compatability
// TODO: Create customization options (pre-built, auto-generated, AI-generated, or completely custom??) to settings
class AppTheme {
  // static const darkest = Color.fromARGB(255, 45, 45, 145);
  // static const dark = Color.fromARGB(255, 81, 81, 196);
  // static const medium = Color.fromARGB(255, 107, 107, 201);
  // static const light = Color.fromARGB(255, 155, 155, 255);
  // static const lightest = Color.fromARGB(255, 172, 175, 255);

  static const darkest = Color.fromARGB(255, 18, 18, 18);
  static const dark = Color.fromARGB(255, 27, 27, 27);
  static const medium = Color.fromARGB(255, 36, 36, 36);
  static const light = Color.fromARGB(255, 45, 45, 45);
  static const lightest = Color.fromARGB(255, 54, 54, 54);
  static const lighterest = Color.fromARGB(255, 145, 145, 145);
  static const white = Colors.white;

  static const accent = Color.fromARGB(255, 155, 155, 255);
  static const accent2 = Color.fromARGB(255, 172, 175, 255);

  static const primaryBackground = darkest;
  static const secondaryBackground = medium;
  static const primaryTextColor = white;
  static const primaryText = TextStyle(color: primaryTextColor, fontSize: 16);
  static const secondaryText = lightest;

  static const accent1 = lightest;
  static const accent4 = accent2;
  static const primary = dark;
  static const secondary = medium;
  static const tertiary = light;
  static const alternate = lightest;

  static const bodyLarge = TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold);
  static const bodyMedium = TextStyle(color: white, fontSize: 16);
  static const bodySmall = TextStyle(color: white, fontSize: 12);

  static const error = Colors.red;
  static const info = Colors.grey;

  static const displayLarge = TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold);
  static const displayMedium = TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.bold);
  static const displaySmall = TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold);

  static const labelLarge = TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold);
  static const labelMedium = TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.bold);
  static const labelSmall = TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.bold);

  static const headlineLarge = TextStyle(color: white, fontWeight: FontWeight.bold);
  static const headlineMedium = TextStyle(color: white, fontWeight: FontWeight.bold);
  static const headlineSmall = TextStyle(color: white, fontWeight: FontWeight.bold);

  static const titleLarge = TextStyle(fontFamily: 'Outfit', letterSpacing: 0, fontSize: 24);
  static const titleSmall = TextStyle(fontFamily: 'Outfit', letterSpacing: 0, fontSize: 16);

}