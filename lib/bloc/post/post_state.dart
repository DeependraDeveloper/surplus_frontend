part of 'post_bloc.dart';

class PostState extends Equatable {
  const PostState({
    this.posts = const <Post>[],
    this.searchedPosts = const <Post>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
    this.range = 5,
  });

  final List<Post> posts;
  final List<Post> searchedPosts;
  final bool isLoading;
  final String error;
  final String message;
  final double range;

  PostState copyWith({
    List<Post>? posts,
    List<Post>? searchedPosts,
    bool? isLoading,
    String? error,
    String? message,
    double? range,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      range: range ?? this.range,
      searchedPosts: searchedPosts ?? this.searchedPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  const PostState.empty() : this();

  factory PostState.fromJson(Map<String, dynamic> json) => PostState(
        posts: json['HydratedPosts']
                ?.map<Post>((x) => Post.fromJson(x))
                ?.toList() ??
            <Post>[],
      );

  Map<String, dynamic> toJson() => {
        'HydratedPosts': posts.map((post) => post.toJson()).toList(),
      };

  @override
  List<Object> get props => [posts, isLoading, error, message, range];
}
