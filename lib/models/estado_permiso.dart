/// Resultado de revisar el GPS y el permiso de ubicación.
enum EstadoPermiso {
  concedido, // Podemos usar el GPS
  gpsApagado, // El servicio de ubicación del teléfono está desactivado
  negado, // El usuario tocó "No permitir" (se le puede volver a preguntar)
  negadoParaSiempre, // Ya no se puede preguntar: solo desde Ajustes
}

extension MensajeEstadoPermiso on EstadoPermiso {
  /// Mensaje que ve el usuario según el estado del permiso.
  String get mensaje => switch (this) {
        EstadoPermiso.concedido => 'Permiso concedido',
        EstadoPermiso.gpsApagado => 'El GPS está apagado. Enciéndelo para continuar.',
        EstadoPermiso.negado => 'Permiso negado. Sin él no podemos mostrar tu ubicación.',
        EstadoPermiso.negadoParaSiempre =>
          'Permiso bloqueado. Actívalo desde los ajustes de la app.',
      };
}
