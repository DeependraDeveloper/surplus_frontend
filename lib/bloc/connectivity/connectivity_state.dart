part of 'connectivity_bloc.dart';

enum ConnectivityStatus { connected, disconnected }

class ConnectivityState extends Equatable {
  const ConnectivityState({
    this.status = ConnectivityStatus.connected,
    this.connectivityType = ConnectivityResult.other,
    this.busy = false,
    this.error = '',
    this.message = '',
  });

  final ConnectivityStatus status;
  final ConnectivityResult connectivityType;
  final bool busy;
  final String error;
  final String message;

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    ConnectivityResult? connectivityType,
    bool? busy,
    String? error,
    String? message,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      connectivityType: connectivityType ?? this.connectivityType,
      busy: busy ?? this.busy,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [status, connectivityType, busy, error, message];
}
