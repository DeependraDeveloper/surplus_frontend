import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({required this.connectivity, required this.dio})
      : super(const ConnectivityState()) {
    dio.options.sendTimeout = const Duration(seconds: 4);
    dio.options.receiveTimeout = const Duration(seconds: 4);
    dio.options.connectTimeout = const Duration(seconds: 4);

    on<ConnectivityChecker>(_onConnectivityChecker);
    on<InternetChecker>(_onInternetChecker);
    on<ConnectivitySetter>(_onConnectivitySetter);

    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn ||
          result == ConnectivityResult.other) {
        add(
          ConnectivitySetter(
              status: ConnectivityStatus.connected, connectivityType: result),
        );

        add(InternetChecker(connectivityType: result));
      } else {
        add(
          ConnectivitySetter(
              status: ConnectivityStatus.disconnected,
              connectivityType: result),
        );
      }
    });
  }

  StreamSubscription? subscription;
  final Connectivity connectivity;
  final Dio dio;
  FutureOr<void> _onConnectivityChecker(
      ConnectivityChecker event, Emitter<ConnectivityState> emit) async {
    final result = await connectivity.checkConnectivity();

    emit(state.copyWith(connectivityType: result));

    add(InternetChecker(connectivityType: result));
  }

  FutureOr<void> _onInternetChecker(
      InternetChecker event, Emitter<ConnectivityState> emit) async {
    try {
      final index = Random().nextInt(3);

      final response = await dio.get(ips[index]);

      if (response.statusCode == 200) {
        emit(state.copyWith(
            status: ConnectivityStatus.connected,
            connectivityType: event.connectivityType));
      } else {
        emit(
          state.copyWith(
            status: ConnectivityStatus.disconnected,
            connectivityType: event.connectivityType,
          ),
        );
      }
    } on DioException catch (_) {
      emit(
        state.copyWith(
          status: ConnectivityStatus.disconnected,
          connectivityType: event.connectivityType,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ConnectivityStatus.disconnected,
          connectivityType: event.connectivityType,
        ),
      );
    }
  }

  FutureOr<void> _onConnectivitySetter(
      ConnectivitySetter event, Emitter<ConnectivityState> emit) {}

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}

// cloudFlare and google dns
const ips = [
  'https://1.1.1.1',
  'https://1.0.0.1',
  'https://8.8.8.8',
  'https://8.8.4.4',
];
