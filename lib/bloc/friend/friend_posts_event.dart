part of 'friend_posts_bloc.dart';

sealed class FriendPostsEvent extends Equatable {
  const FriendPostsEvent();

  @override
  List<Object> get props => [];
}

final class FriendPostLoadEvent extends FriendPostsEvent {
  final String userId;

  const FriendPostLoadEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
