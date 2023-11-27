import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:surplus/bloc/auth/authentication_bloc.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/models/user.dart';
import 'package:surplus/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  UserBloc({
    required this.repository,
    required this.authBloc,
  }) : super(const UserState()) {
    on<SignUpEvent>(_onSignUpEvent);
    on<SignInEvent>(_onSignInEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<ClearUser>(_onClearUser);
    on<GetUserEvent>(_onGetUserEvent);
  }

  final UserRepository repository;
  final AuthenticationBloc authBloc;
  FutureOr<void> _onSignInEvent(
      SignInEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));

    try {
      final response = await repository.signIn(
        phone: event.phone,
        password: event.password,
        lat: event.lat,
        long: event.long,
      );

      if (response.success) {
        final data = response.data as User;
        emit(state.copyWith(
          isLoading: false,
          user: data,
          message: response.message,
        ));
        authBloc.add(AuthenticationAuthenticated());

        await HydratedBloc.storage.write('token', data.accessToken);
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error : $_',
        ),
      );
    }
  }

  FutureOr<void> _onSignUpEvent(
      SignUpEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));

    try {
      final response = await repository.signUp(
        email: event.email,
        phone: event.phone,
        password: event.password,
        lat: event.lat,
        long: event.long,
        name: event.name,
      );

      if (response.success) {
        final data = response.data as User;
        emit(state.copyWith(
          isLoading: false,
          user: data,
          message: response.message,
        ));

        authBloc.add(AuthenticationAuthenticated());

        await HydratedBloc.storage.write('token', data.accessToken);
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error : $_',
        ),
      );
    }
  }

  Future<FutureOr<void>> _onResetPasswordEvent(
      ResetPasswordEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));

    try {
      final response = await repository.resetPassword(
        phone: event.phone,
        password: event.password,
        reEnteredPassword: event.reEnteredpassword,
      );

      if (response.success) {
        final data = response.data as User;
        emit(state.copyWith(
          isLoading: false,
          user: data,
          message: response.message,
        ));

        authBloc.add(AuthenticationAuthenticated());
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error : $_',
        ),
      );
    }
  }

  FutureOr<void> _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.updateProfile(
        event.userId,
        event.name,
        event.email,
        event.phone,
        event.image,
      );

      if (response.success) {
        final data = response.data as User;

        emit(state.copyWith(
          isLoading: false,
          user: data,
          message: response.message,
        ));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error : $_',
        ),
      );
    }
  }

  FutureOr<void> _onClearUser(ClearUser event, Emitter<UserState> emit) {
    emit(const UserState());
  }

  Future<FutureOr<void>> _onGetUserEvent(
      GetUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.getProfile(
        userId: event.userId,
      );

      if (response.success) {
        final data = response.data as User;

        emit(state.copyWith(
          isLoading: false,
          user: data,
          message: response.message,
        ));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Error : ${response.message}',
          ),
        );
      }
    } on Exception catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Error : $_',
        ),
      );
    }
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) => UserState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserState state) => state.toJson();
}
