part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState({
    this.position,
    this.isPermissionGranted = true,
    this.isLoading = false,
    this.error = '',
  });
  final Position? position;
  final bool isPermissionGranted;
  final bool isLoading;

  final String error;

  /// empty location state
  factory LocationState.empty() => const LocationState();

  /// copy with location state
  LocationState copyWith({
    Position? position,
    bool? isPermissionGranted,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      position: position ?? this.position,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  

  @override
  List<Object?> get props => [
        position,
        isPermissionGranted,
        isLoading,
        error,
      ];
}
