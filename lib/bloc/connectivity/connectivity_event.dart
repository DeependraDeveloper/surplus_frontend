part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

final class ConnectivitySetter extends ConnectivityEvent {
  const ConnectivitySetter(
      {required this.status,
      required this.connectivityType,
      this.busy = false,
      this.error = '',
      this.message = ''});

  final ConnectivityStatus status;
  final ConnectivityResult connectivityType;
  final bool busy;
  final String error;
  final String message;

  @override
  List<Object> get props => [status, connectivityType, busy, error, message];
}

final class ConnectivityChecker extends ConnectivityEvent {
  const ConnectivityChecker();
  @override
  List<Object> get props => [];
}

final class InternetChecker extends ConnectivityEvent {
  const InternetChecker({required this.connectivityType});

  final ConnectivityResult connectivityType;

  @override
  List<Object> get props => [connectivityType];
}
