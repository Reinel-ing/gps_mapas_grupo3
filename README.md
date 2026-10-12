# GPS y Mapas con Flutter · Grupo 3

Video tutorial y app de ejemplo para **Programación Móvil (SS603, grupo 04)** de la Universidad Popular del Cesar.

La app obtiene la ubicación del dispositivo con [`geolocator`](https://pub.dev/packages/geolocator) y la muestra en un mapa de Google con [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter). Pide el permiso de ubicación y funciona tanto si el usuario lo acepta como si lo niega.

**Video tutorial:** [Ver en YouTube](ENLACE_DEL_VIDEO)

## Integrantes

| Nombre | Qué explicó en el video |
|---|---|
| Frell Beleño | Presentación con diapositivas: introducción, explicación del tema, permisos en Android, iOS y Web, buenas prácticas y cierre |
| Reinel Alfaro | Implementación del código: pubspec.yaml, solicitud del permiso, lógica principal y manejo de errores |
| Kevin Perea | Demostración de la app: negando y aceptando el permiso de ubicación |

## Funcionalidades

- Muestra un mapa de Google con un marcador en la ubicación actual.
- Pide el permiso de ubicación en tiempo de ejecución, solo cuando el usuario toca "Obtener ubicación".
- Muestra la latitud, la longitud y la precisión en metros.
- Seguimiento en vivo: el marcador se mueve cada vez que el usuario avanza 5 metros.
- Maneja todos los casos del permiso:

| Caso | Qué hace la app |
|---|---|
| Permiso concedido | Muestra la ubicación en el mapa |
| GPS apagado | Avisa y muestra el botón **Encender GPS** |
| Permiso negado | Avisa que sin el permiso no puede mostrar la ubicación |
| Permiso bloqueado (negado para siempre) | Muestra el botón **Abrir ajustes** para activarlo a mano |

## Tecnologías

- Flutter y Dart (SDK ^3.13.2)
- [`geolocator`](https://pub.dev/packages/geolocator) ^14.1.1: ubicación, permisos y seguimiento en tiempo real
- [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter) ^2.18.2: mapa de Google con marcadores y control de cámara

```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^14.1.1
  google_maps_flutter: ^2.18.2
```

## Estructura del proyecto

```
lib/
├── main.dart                          # Solo arranca la app
├── core/
│   ├── constants/constantes_mapa.dart # Valores fijos (punto inicial, zoom, seguimiento)
│   └── theme/tema_app.dart            # Colores y tema
├── models/
│   └── estado_permiso.dart            # Estados del permiso y sus mensajes
├── services/
│   └── servicio_ubicacion.dart        # Lógica del GPS y de los permisos
├── screens/
│   └── mapa/pantalla_mapa.dart        # Pantalla principal (estado y acciones)
└── widgets/
    ├── mapa_ubicacion.dart            # Mapa de Google con el marcador
    └── panel_ubicacion.dart           # Coordenadas, mensaje y botones
test/
└── widget_test.dart                   # Prueba de los mensajes de cada estado
```

Cada archivo tiene una sola responsabilidad: el servicio tiene la lógica del GPS y la pantalla solo muestra los datos.

## Permisos por plataforma

### Android

En `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="${MAPS_API_KEY}" />
```

- `ACCESS_FINE_LOCATION`: ubicación precisa (GPS).
- `ACCESS_COARSE_LOCATION`: ubicación aproximada (WiFi y antenas). Desde Android 12 el usuario puede escoger entre precisa y aproximada.
- `INTERNET`: para descargar el mapa.
- La ubicación es un permiso peligroso: además de declararlo, se pide con un diálogo mientras la app está abierta.
- La versión mínima es Android 7.0 (`minSdk 24`).

### iOS

En `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>La app usa tu ubicación para mostrarte en el mapa dónde estás.</string>
```

- Ese texto es el que ve el usuario en el diálogo del permiso. Si falta, iOS cierra la app.
- La app solo usa la ubicación mientras está abierta, no en segundo plano.
- La clave de Google Maps va en `ios/Runner/AppDelegate.swift` con `GMSServices.provideAPIKey("TU_API_KEY")`.

### Web

- El navegador pide el permiso con su propio aviso (Geolocation API).
- Solo funciona con HTTPS, o con `localhost` mientras se desarrolla.
- Si el usuario bloquea el permiso, se vuelve a activar desde el candado de la barra de direcciones.
- El mapa necesita el script de la Maps JavaScript API en `web/index.html`.

## Cómo funciona

`ServicioUbicacion.verificarPermisos()` revisa cuatro cosas en orden:

1. `Geolocator.isLocationServiceEnabled()`: si el GPS está encendido.
2. `Geolocator.checkPermission()`: qué permiso tiene la app.
3. `Geolocator.requestPermission()`: si está negado, muestra el diálogo del sistema.
4. Convierte la respuesta en uno de los cuatro estados de `EstadoPermiso`.

Con el permiso concedido:

- `getCurrentPosition()` obtiene una sola lectura con alta precisión y un límite de 15 segundos.
- `getPositionStream()` con `distanceFilter: 5` sigue la ubicación en vivo y solo avisa cuando el usuario se mueve 5 metros, para ahorrar batería.
- `GoogleMap` muestra el marcador "Estás aquí" y `animateCamera()` mueve el mapa a cada nueva posición.

### Manejo de errores

- La lectura de la ubicación está en un `try-catch`: si no hay señal o se acaba el tiempo, la app muestra el error y no se cierra.
- En `dispose()` se cancela el seguimiento para liberar el GPS al salir de la pantalla.

## Cómo ejecutarlo

### 1. Clonar e instalar

```bash
git clone https://github.com/Reinel-ing/gps_mapas_grupo3.git
cd gps_mapas_grupo3
flutter pub get
```

### 2. Crear la clave de Google Maps

1. Entrar a [Google Cloud Console](https://console.cloud.google.com/) y crear un proyecto.
2. Activar **Maps SDK for Android** (y **Maps JavaScript API** si se va a usar en Web).
3. Ir a **Credenciales** → **Crear credenciales** → **Clave de API**.

### 3. Guardar la clave

Crear el archivo `claves.json` en la raíz del proyecto:

```json
{ "MAPS_API_KEY": "tu_clave" }
```

`claves.json` está en `.gitignore`, así que la clave nunca se sube al repositorio.

### 4. Ejecutar

```bash
# Android (celular o emulador)
flutter run --dart-define-from-file=claves.json

# Web: antes cambiar TU_API_KEY por la clave en web/index.html
flutter run -d chrome
```

En el emulador de Android la ubicación se cambia desde **⋯ → Location**.

### Pruebas

```bash
flutter test
```

## Buenas prácticas aplicadas

- Pedir solo los permisos necesarios: no se usa la ubicación en segundo plano.
- Pedir el permiso en el momento en que se necesita, no al abrir la app.
- Explicar al usuario para qué se usa su ubicación.
- Respetar cuando el usuario dice que no: la app sigue funcionando.
- Apagar el seguimiento cuando no se usa para ahorrar batería.
- No subir claves ni contraseñas al repositorio.

## Dificultades

- Configurar la clave de Google Maps (activar las APIs y la facturación de Google Cloud) sin dejarla escrita en el código.
- Probar los distintos casos del permiso: para que el diálogo vuelva a salir hay que desinstalar la app.

## Conclusiones

- Con `geolocator`, usar el GPS en Flutter es sencillo.
- Lo más importante son los permisos: declararlos, pedirlos y respetar la respuesta del usuario.
- Una buena app sigue funcionando aunque el usuario niegue el permiso.

## Créditos

- Grupo 3: Frell Beleño, Reinel Alfaro y Kevin Perea.
- Programación Móvil SS603, grupo 04. Universidad Popular del Cesar, 2026.
- Paquetes: [`geolocator`](https://pub.dev/packages/geolocator) y [`google_maps_flutter`](https://pub.dev/packages/google_maps_flutter).
