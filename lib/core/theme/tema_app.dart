import 'package:flutter/material.dart';

/// Tema visual de la app.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      );
}
