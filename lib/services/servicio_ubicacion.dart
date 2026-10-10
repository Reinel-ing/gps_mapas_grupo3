import 'package:geolocator/geolocator.dart';

import '../core/constants/constantes_mapa.dart';
import '../models/estado_permiso.dart';

class ServicioUbicacion {
  Future<EstadoPermiso> verificarPermisos() async {
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (!gpsActivo) return EstadoPermiso.gpsApagado;

    var permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    switch (permiso) {
      case LocationPermission.denied:
        return EstadoPermiso.negado;
      case LocationPermission.deniedForever:
        return EstadoPermiso.negadoParaSiempre;
      default:
        return EstadoPermiso.concedido;
    }
  }

  Future<Position> obtenerPosicion() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: ConstantesMapa.tiempoMaximoLectura,
      ),
    );
  }

  Stream<Position> seguirPosicion() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: ConstantesMapa.metrosEntreActualizaciones,
      ),
    );
  }

  Future<bool> abrirAjustesApp() => Geolocator.openAppSettings();

  Future<bool> abrirAjustesGps() => Geolocator.openLocationSettings();
}
