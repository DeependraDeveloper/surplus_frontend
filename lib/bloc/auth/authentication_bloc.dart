import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';



class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState>
    with ChangeNotifier {
  AuthenticationBloc() : super(AuthenticationState.unauthenticated) {

    on<AuthenticationAuthenticated>(_onAuthenticationAuthenticated);
    on<AuthenticationUnAuthenticated>(_onAuthenticationUnAuthenticated);
  }

  FutureOr<void> _onAuthenticationAuthenticated(
      AuthenticationAuthenticated event, Emitter<AuthenticationState> emit) {

    emit(AuthenticationState.authenticated);
    notifyListeners();
  }

  FutureOr<void> _onAuthenticationUnAuthenticated(
      AuthenticationUnAuthenticated event,
      Emitter<AuthenticationState> emit) async {

    emit(AuthenticationState.unauthenticated);

    await HydratedBloc.storage.clear();
    notifyListeners();
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    return AuthenticationState.values[json['AuthenticationState'] as int];
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) => {
        'AuthenticationState': state.index,
      };
}
