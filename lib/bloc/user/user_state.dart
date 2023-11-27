part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({
    this.user = const User(),
    this.userPosts = const <Post>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });

  final List<Post> userPosts;
  final User user;
  final bool isLoading;
  final String error;
  final String message;

  UserState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    String? message,
    List<Post>? userPosts,
  }) {
    return UserState(
      user: user ?? this.user,
      userPosts: userPosts ?? this.userPosts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  factory UserState.fromJson(Map<String, dynamic> json) => UserState(
        user: User.fromJson(json['user'] ?? <String, dynamic>{}),
      );

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };

  @override
  List<Object?> get props => [user, isLoading, error, message, userPosts];
}
