import 'package:flutter/material.dart';

import 'core/theme/tema_app.dart';
import 'screens/mapa/pantalla_mapa.dart';

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
