import 'package:flutter/material.dart';

import 'core/theme/tema_app.dart';
import 'screens/mapa/pantalla_mapa.dart';

/// GPS y mapas con Flutter
/// Grupo 3 - Programación Móvil SS603 (Grupo 04)
/// Kevin Perea · Frell Beleño · Reinel Alfaro
void main() => runApp(const GpsApp());

class GpsApp extends StatelessWidget {
  const GpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS y Mapas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PantallaMapa(),
    );
  }
}
