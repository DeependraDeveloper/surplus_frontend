import 'package:geolocator/geolocator.dart' as geo;

class LocationService {
  LocationService();

  /// [permissionStatusStream] returns the current permission status
  /// of the application.
  Stream<geo.ServiceStatus> get permissionStatusStream =>
      geo.Geolocator.getServiceStatusStream();

  /// [locationStream] returns the current location of the device.
  Stream<geo.Position> get positionStream => geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          distanceFilter: 500,
          timeLimit: Duration(minutes: 10),
        ),
      );

  /// [permissionStatus] returns the current permission status
  /// of the application.
  /// This is used to determine if the application has the
  /// required permissions to access the device's location.
  /// If the application does not have the required permissions,
  /// the user will be prompted to grant the permissions.
  /// If the user denies the permissions, the application will
  /// redirect the user to the settings page to grant the permissions.

  Future<bool> permissionStatus() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      final currentPermission = await geo.Geolocator.checkPermission();
      if (currentPermission == geo.LocationPermission.whileInUse ||
          currentPermission == geo.LocationPermission.always) {
        return true;
      }

      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  /// [requestPermission] requests the user to grant the
  /// required permissions to access the device's location.

  Future<bool> requestPermission() async {
    try {
      final permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.whileInUse ||
          permission == geo.LocationPermission.always) {
        return true;
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  /// [currentLocation] returns the current location of the device.
  /// This is used to get the current location of the device to
  /// display the weather data of the current location.
  Future<geo.Position> currentLocation() async {
    try {
      final position = await geo.Geolocator.getCurrentPosition();
      return position;
    } on Exception catch (_) {
      // print('currentLocation: $_');
      return geo.Position(
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        floor: 0,
        isMocked: true,
      );
    }
  }
}
