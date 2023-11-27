part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

final class SignUpEvent extends UserEvent {
  const SignUpEvent({
    required this.lat,
    required this.long,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
  final String name;
  final String email;
  final int phone;
  final String password;
  final double lat;
  final double long;

  @override
  List<Object> get props => [name, email, phone, password, lat, long];
}

final class SignInEvent extends UserEvent {
  final int phone;
  final String password;
  final double lat;
  final double long;

  const SignInEvent({
    required this.phone,
    required this.password,
    required this.lat,
    required this.long,
  });

  @override
  List<Object> get props => [phone, password, lat, long];
}

final class ResetPasswordEvent extends UserEvent {
  final int phone;
  final String password;
  final String reEnteredpassword;

  const ResetPasswordEvent(
      {required this.phone,
      required this.password,
      required this.reEnteredpassword});

  @override
  List<Object> get props => [phone, password, reEnteredpassword];
}

final class UpdateProfileEvent extends UserEvent {
  final String userId;
  final String name;
  final String email;
  final int phone;
  final File? image;

  const UpdateProfileEvent({
    required this.phone,
    required this.userId,
    required this.name,
    required this.email,
    this.image,
  });

  @override
  List<Object?> get props => [phone, userId, name, email, image];
}



final class ClearUser extends UserEvent {}
