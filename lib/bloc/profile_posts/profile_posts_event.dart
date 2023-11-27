part of 'profile_posts_bloc.dart';

sealed class ProfilePostsEvent extends Equatable {
  const ProfilePostsEvent();

  @override
  List<Object> get props => [];
}

final class UserPostLoadEvent extends ProfilePostsEvent {
  final String userId;

  const UserPostLoadEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
