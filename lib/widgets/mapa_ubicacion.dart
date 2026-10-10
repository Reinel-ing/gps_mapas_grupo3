import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/constants/constantes_mapa.dart';

/// Mapa de Google (google_maps_flutter) con el marcador "Estás aquí".
class MapaUbicacion extends StatefulWidget {
  const MapaUbicacion({super.key, required this.posicion});

  final Position? posicion;

  @override
  State<MapaUbicacion> createState() => _MapaUbicacionState();
}

class _MapaUbicacionState extends State<MapaUbicacion> {
  GoogleMapController? _controlador; // Controla la cámara del mapa

  /// Cada vez que llega una posición nueva, la cámara se mueve hasta ella.
  @override
  void didUpdateWidget(covariant MapaUbicacion anterior) {
    super.didUpdateWidget(anterior);
    final pos = widget.posicion;
    if (pos != null && pos != anterior.posicion) {
      _controlador?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(pos.latitude, pos.longitude),
          ConstantesMapa.zoomUbicacion,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pos = widget.posicion;

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: ConstantesMapa.puntoInicial,
        zoom: ConstantesMapa.zoomInicial,
      ),
      onMapCreated: (controlador) => _controlador = controlador,
      markers: {
        if (pos != null)
          Marker(
            markerId: const MarkerId('yo'),
            position: LatLng(pos.latitude, pos.longitude),
            infoWindow: const InfoWindow(title: 'Estás aquí'),
          ),
      },
    );
  }
}
