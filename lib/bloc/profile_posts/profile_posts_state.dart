part of 'profile_posts_bloc.dart';

class ProfilePostsState extends Equatable {
  const ProfilePostsState({
    this.userPosts = const <Post>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });

  final List<Post> userPosts;
  final bool isLoading;
  final String error;
  final String message;

  ProfilePostsState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<Post>? userPosts,
  }) {
    return ProfilePostsState(
      userPosts: userPosts ?? this.userPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  factory ProfilePostsState.fromJson(Map<String, dynamic> json) =>
      ProfilePostsState(
        userPosts:
            json['userPosts']?.map<Post>((x) => Post.fromJson(x))?.toList() ??
                <Post>[],
      );

  Map<String, dynamic> toJson() => {
        'userPosts': userPosts.map((post) => post.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        userPosts,
      ];
}
