part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object> get props => [];
}

class LocationPermissionEvent extends LocationEvent {}

class RequestLocationPermissionEvent extends LocationEvent {}

class CurrentLocationEvent extends LocationEvent {}

