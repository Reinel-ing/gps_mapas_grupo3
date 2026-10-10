import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Valores fijos del mapa y del GPS.
class ConstantesMapa {
  ConstantesMapa._();

  /// Punto inicial mientras llega el GPS: Valledupar.
  static const LatLng puntoInicial = LatLng(10.4631, -73.2532);

  /// Zoom al abrir la app y al encontrar la ubicación.
  static const double zoomInicial = 13;
  static const double zoomUbicacion = 17;

  /// Seguimiento en vivo: solo avisa si nos movemos esta cantidad de metros.
  static const int metrosEntreActualizaciones = 5;

  /// Tiempo máximo para una lectura del GPS.
  static const Duration tiempoMaximoLectura = Duration(seconds: 15);
}
