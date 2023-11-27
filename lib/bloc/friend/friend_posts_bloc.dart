import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/repositories/user_repository.dart';

part 'friend_posts_event.dart';
part 'friend_posts_state.dart';

class FriendPostsBloc extends HydratedBloc<FriendPostsEvent, FriendPostsState> {
  FriendPostsBloc({required this.repository})
      : super(const FriendPostsState()) {
    on<FriendPostLoadEvent>(_onFriendPostLoadEvent);
  }

  final UserRepository repository;

  Future<FutureOr<void>> _onFriendPostLoadEvent(
      FriendPostLoadEvent event, Emitter<FriendPostsState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.getUserPosts(userId: event.userId);

      if (response.success) {
        final data = response.data as List<Post>;
        emit(state.copyWith(
          isLoading: false,
          friendPosts: data,
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
      emit(state.copyWith(isLoading: false, error: 'Error : $_'));
    }
  }

  @override
  FriendPostsState? fromJson(Map<String, dynamic> json) =>
      FriendPostsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(FriendPostsState state) => state.toJson();
}
