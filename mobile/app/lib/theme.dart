import 'package:flutter/material.dart';

class AppTheme {
  static const darkest = Color.fromARGB(255, 45, 45, 145);
  static const dark = Color.fromARGB(255, 81, 81, 196);
  static const medium = Color.fromARGB(255, 107, 107, 201);
  static const light = Color.fromARGB(255, 155, 155, 255);
  static const lightest = Color.fromARGB(255, 172, 175, 255);
  static const accent = Color.fromARGB(255, 255, 113, 0);
  static const accent2 = Color.fromARGB(255, 255, 164, 79);

  static const primaryBackground = darkest;
  static const secondaryBackground = medium;
  static const primaryTextColor = darkest;
  static const primaryText = TextStyle(color: primaryTextColor, fontSize: 16);
  static const secondaryText = dark;

  static const accent1 = lightest;
  static const accent4 = accent2;
  static const primary = dark;
  static const secondary = medium;
  static const tertiary = light;
  static const alternate = lightest;

  static const bodyLarge = TextStyle(color: light, fontSize: 24, fontWeight: FontWeight.bold);
  static const bodyMedium = TextStyle(color: lightest, fontSize: 16);
  static const bodySmall = TextStyle(color: light, fontSize: 12);

  static const error = Colors.red;
  static const info = Colors.grey;

  static const displayLarge = TextStyle(color: darkest, fontSize: 24, fontWeight: FontWeight.bold);
  static const displayMedium = TextStyle(color: dark, fontSize: 16, fontWeight: FontWeight.bold);
  static const displaySmall = TextStyle(color: lightest, fontSize: 12, fontWeight: FontWeight.bold);

  static const labelLarge = TextStyle(color: darkest, fontSize: 24, fontWeight: FontWeight.bold);
  static const labelMedium = TextStyle(color: dark, fontSize: 16, fontWeight: FontWeight.bold);
  static const labelSmall = TextStyle(color: medium, fontSize: 12, fontWeight: FontWeight.bold);

  static const headlineLarge = TextStyle(color: medium, fontWeight: FontWeight.bold);
  static const headlineMedium = TextStyle(color: light, fontWeight: FontWeight.bold);
  static const headlineSmall = TextStyle(color: lightest, fontWeight: FontWeight.bold);

  static const titleLarge = TextStyle(fontFamily: 'Outfit', letterSpacing: 0, fontSize: 24);
  static const titleSmall = TextStyle(fontFamily: 'Outfit', letterSpacing: 0, fontSize: 16);

}