enum EstadoPermiso {
  concedido,
  gpsApagado,
  negado,
  negadoParaSiempre,
}

extension MensajeEstadoPermiso on EstadoPermiso {
  String get mensaje => switch (this) {
        EstadoPermiso.concedido => 'Permiso concedido',
        EstadoPermiso.gpsApagado => 'El GPS está apagado. Enciéndelo para continuar.',
        EstadoPermiso.negado => 'Permiso negado. Sin él no podemos mostrar tu ubicación.',
        EstadoPermiso.negadoParaSiempre =>
          'Permiso bloqueado. Actívalo desde los ajustes de la app.',
      };
}
