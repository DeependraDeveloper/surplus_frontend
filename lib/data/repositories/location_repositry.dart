import 'package:surplus/data/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  Future<bool> permissionStatus();
  Future<Position> currentLocation();
  Future<bool> requestPermission();

  Stream<Position> get positionStream;
  Stream<ServiceStatus> get permissionStatusStream;
}

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl({required this.locationService});
  final LocationService locationService;

  @override
  Future<bool> permissionStatus() => locationService.permissionStatus();

  @override
  Future<bool> requestPermission() => locationService.requestPermission();

  @override
  Future<Position> currentLocation() => locationService.currentLocation();
 

  @override
  Stream<Position> get positionStream => locationService.positionStream;

  @override
  Stream<ServiceStatus> get permissionStatusStream =>
      locationService.permissionStatusStream;
}
