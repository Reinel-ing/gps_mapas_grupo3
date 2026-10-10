import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/estado_permiso.dart';

/// Panel inferior: coordenadas, mensaje de estado y botones.
class PanelUbicacion extends StatelessWidget {
  const PanelUbicacion({
    super.key,
    required this.posicion,
    required this.mensaje,
    required this.estadoPermiso,
    required this.siguiendo,
    required this.onObtenerUbicacion,
    required this.onAlternarSeguimiento,
    required this.onAbrirAjustesApp,
    required this.onAbrirAjustesGps,
  });

  final Position? posicion;
  final String mensaje;
  final EstadoPermiso? estadoPermiso;
  final bool siguiendo;
  final VoidCallback onObtenerUbicacion;
  final VoidCallback onAlternarSeguimiento;
  final VoidCallback onAbrirAjustesApp;
  final VoidCallback onAbrirAjustesGps;

  @override
  Widget build(BuildContext context) {
    final pos = posicion;
    final tema = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: tema.colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pos == null
                ? 'Latitud: --   Longitud: --'
                : 'Latitud: ${pos.latitude.toStringAsFixed(6)}   '
                    'Longitud: ${pos.longitude.toStringAsFixed(6)}',
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(mensaje),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onObtenerUbicacion,
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener ubicación'),
              ),
              OutlinedButton.icon(
                onPressed: onAlternarSeguimiento,
                icon: Icon(siguiendo ? Icons.stop : Icons.play_arrow),
                label: Text(siguiendo ? 'Detener' : 'Seguir en vivo'),
              ),
              // Solo si el permiso quedó bloqueado (en Web no existe).
              if (estadoPermiso == EstadoPermiso.negadoParaSiempre && !kIsWeb)
                TextButton.icon(
                  onPressed: onAbrirAjustesApp,
                  icon: const Icon(Icons.settings),
                  label: const Text('Abrir ajustes'),
                ),
              // Solo si el GPS del teléfono está apagado.
              if (estadoPermiso == EstadoPermiso.gpsApagado && !kIsWeb)
                TextButton.icon(
                  onPressed: onAbrirAjustesGps,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Encender GPS'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
