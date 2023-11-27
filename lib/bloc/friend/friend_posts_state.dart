part of 'friend_posts_bloc.dart';

class FriendPostsState extends Equatable {
  const FriendPostsState({
    this.friendPosts = const <Post>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });

  final List<Post> friendPosts;
  final bool isLoading;
  final String error;
  final String message;

  FriendPostsState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<Post>? friendPosts,
  }) {
    return FriendPostsState(
      friendPosts: friendPosts ?? this.friendPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  factory FriendPostsState.fromJson(Map<String, dynamic> json) =>
      FriendPostsState(
        friendPosts:
            json['friendPosts']?.map<Post>((x) => Post.fromJson(x))?.toList() ??
                <Post>[],
      );

  Map<String, dynamic> toJson() => {
        'friendPosts': friendPosts.map((post) => post.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        friendPosts,
      ];
}
