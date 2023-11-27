part of 'authentication_bloc.dart';

class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AuthenticationAuthenticated extends AuthenticationEvent {}

class AuthenticationUnAuthenticated extends AuthenticationEvent {}
