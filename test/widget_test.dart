import 'package:flutter_test/flutter_test.dart';
import 'package:gps_mapas_grupo3/models/estado_permiso.dart';

void main() {
  test('Cada estado de permiso tiene un mensaje para el usuario', () {
    for (final estado in EstadoPermiso.values) {
      expect(estado.mensaje, isNotEmpty);
    }
  });
}
