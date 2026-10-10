import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConstantesMapa {
  ConstantesMapa._();

  static const LatLng puntoInicial = LatLng(10.4631, -73.2532);

  static const double zoomInicial = 13;
  static const double zoomUbicacion = 17;

  static const int metrosEntreActualizaciones = 5;

  static const Duration tiempoMaximoLectura = Duration(seconds: 15);
}
