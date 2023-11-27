import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:surplus/data/repositories/location_repositry.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;

  LocationBloc({
    required this.locationRepository,
  }) : super(LocationState.empty()) {
    on<LocationPermissionEvent>(_onLocationPermissionEvent);
    on<RequestLocationPermissionEvent>(_onRequestLocationPermissionEvent);
    on<CurrentLocationEvent>(_onCurrentLocationEvent);
  }

  Future<FutureOr<void>> _onLocationPermissionEvent(
      LocationPermissionEvent event, Emitter<LocationState> emit) async {
    try {
      emit(
        state.copyWith(isLoading: true, error: '', isPermissionGranted: false),
      );
      final isPermissionGranted = await locationRepository.permissionStatus();
      if (isPermissionGranted) {
        emit(state.copyWith(
          isPermissionGranted: true,
        ));
        add(CurrentLocationEvent());
      } else {
        emit(
          state.copyWith(
            error: 'Location permission denied or service disabled!',
            isLoading: false,
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          error: 'We are unable to request your location! Please try again.',
          isLoading: false,
        ),
      );
    }
  }

  FutureOr<void> _onRequestLocationPermissionEvent(
      RequestLocationPermissionEvent event, Emitter<LocationState> emit) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: '',
          isPermissionGranted: false,
        ),
      );
      final isPermissionGranted = await locationRepository.requestPermission();
      if (isPermissionGranted) {
        emit(state.copyWith(
          isPermissionGranted: true,
        ));
        add(CurrentLocationEvent());
      } else {
        emit(
          state.copyWith(
            isPermissionGranted: false,
            isLoading: false,
            error: 'We are unable to request your location! Please try again.',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isPermissionGranted: false,
          error: 'We are unable to request your location! Please try again.',
        ),
      );
    }
  }

  FutureOr<void> _onCurrentLocationEvent(
      CurrentLocationEvent event, Emitter<LocationState> emit) async {
    try {
      final position = await locationRepository.currentLocation();

      if (position.latitude == 0 && position.longitude == 0) {
        emit(state.copyWith(
          isLoading: false,
          isPermissionGranted: false,
          error: 'We are unable to access your location! Please try again.',
        ));
        return;
      }

      emit(state.copyWith(
        isLoading: false,
        position: position,
        isPermissionGranted: true,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(
        isLoading: false,
        isPermissionGranted: false,
        error: 'We are unable to access your location! Please try again.',
      ));
    }
  }
}
