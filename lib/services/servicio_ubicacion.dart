import 'package:geolocator/geolocator.dart';

import '../core/constants/constantes_mapa.dart';
import '../models/estado_permiso.dart';

/// Toda la lógica del GPS y de los permisos en un solo lugar.
/// La pantalla solo llama a estos métodos.
class ServicioUbicacion {
  /// PASO CLAVE: revisa el GPS y pide el permiso en tiempo de ejecución.
  Future<EstadoPermiso> verificarPermisos() async {
    // 1. ¿El GPS del teléfono está encendido?
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (!gpsActivo) return EstadoPermiso.gpsApagado;

    // 2. ¿Qué permiso tenemos ahora mismo?
    var permiso = await Geolocator.checkPermission();

    // 3. Si no lo tenemos, se lo pedimos: aquí aparece el diálogo del sistema.
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    // 4. Interpretamos la respuesta del usuario.
    switch (permiso) {
      case LocationPermission.denied:
        return EstadoPermiso.negado;
      case LocationPermission.deniedForever:
        return EstadoPermiso.negadoParaSiempre;
      default:
        // whileInUse (mientras se usa la app) o always (siempre)
        return EstadoPermiso.concedido;
    }
  }

  /// Una sola lectura del GPS con alta precisión.
  Future<Position> obtenerPosicion() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: ConstantesMapa.tiempoMaximoLectura,
      ),
    );
  }

  /// Seguimiento en tiempo real: avisa cada vez que nos movemos unos metros.
  /// El distanceFilter evita actualizaciones inútiles y ahorra batería.
  Stream<Position> seguirPosicion() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: ConstantesMapa.metrosEntreActualizaciones,
      ),
    );
  }

  /// Abre los ajustes de la app para activar el permiso a mano.
  Future<bool> abrirAjustesApp() => Geolocator.openAppSettings();

  /// Abre los ajustes de ubicación del teléfono para encender el GPS.
  Future<bool> abrirAjustesGps() => Geolocator.openLocationSettings();
}
