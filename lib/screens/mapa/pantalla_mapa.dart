import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/estado_permiso.dart';
import '../../services/servicio_ubicacion.dart';
import '../../widgets/mapa_ubicacion.dart';
import '../../widgets/panel_ubicacion.dart';

class PantallaMapa extends StatefulWidget {
  const PantallaMapa({super.key});

  @override
  State<PantallaMapa> createState() => _PantallaMapaState();
}

class _PantallaMapaState extends State<PantallaMapa> {
  final _servicio = ServicioUbicacion();
  Position? _posicion;
  StreamSubscription<Position>? _seguimiento;
  EstadoPermiso? _estadoPermiso;
  String _mensaje = 'Toca "Obtener ubicación" para empezar';

  Future<bool> _puedeUsarGps() async {
    final estado = await _servicio.verificarPermisos();
    setState(() {
      _estadoPermiso = estado;
      _mensaje = estado.mensaje;
    });
    return estado == EstadoPermiso.concedido;
  }

  Future<void> _obtenerUbicacion() async {
    if (!await _puedeUsarGps()) return;
    setState(() => _mensaje = 'Buscando señal GPS...');
    try {
      _actualizar(await _servicio.obtenerPosicion());
    } catch (e) {
      setState(() => _mensaje = 'No se pudo obtener la ubicación: $e');
    }
  }

  Future<void> _alternarSeguimiento() async {
    if (_seguimiento != null) {
      await _seguimiento!.cancel();
      setState(() {
        _seguimiento = null;
        _mensaje = 'Seguimiento detenido';
      });
      return;
    }
    if (!await _puedeUsarGps()) return;
    setState(() {
      _mensaje = 'Siguiendo tu ubicación...';
      _seguimiento = _servicio.seguirPosicion().listen(
            _actualizar,
            onError: (e) => setState(() => _mensaje = 'Error en el seguimiento: $e'),
          );
    });
  }

  void _actualizar(Position pos) {
    setState(() {
      _posicion = pos;
      _mensaje = 'Precisión: ±${pos.accuracy.toStringAsFixed(0)} m';
    });
  }

  @override
  void dispose() {
    _seguimiento?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS y Mapas · Grupo 3')),
      body: Column(
        children: [
          Expanded(
            child: MapaUbicacion(posicion: _posicion),
          ),
          PanelUbicacion(
            posicion: _posicion,
            mensaje: _mensaje,
            estadoPermiso: _estadoPermiso,
            siguiendo: _seguimiento != null,
            onObtenerUbicacion: _obtenerUbicacion,
            onAlternarSeguimiento: _alternarSeguimiento,
            onAbrirAjustesApp: _servicio.abrirAjustesApp,
            onAbrirAjustesGps: _servicio.abrirAjustesGps,
          ),
        ],
      ),
    );
  }
}
