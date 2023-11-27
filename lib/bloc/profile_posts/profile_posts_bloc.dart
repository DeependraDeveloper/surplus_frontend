import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/repositories/user_repository.dart';

part 'profile_posts_event.dart';
part 'profile_posts_state.dart';

class ProfilePostsBloc
    extends HydratedBloc<ProfilePostsEvent, ProfilePostsState> {
  ProfilePostsBloc({required this.repository})
      : super(const ProfilePostsState()) {
    on<UserPostLoadEvent>(_onUserPostLoadEvent);
  }

  final UserRepository repository;

  FutureOr<void> _onUserPostLoadEvent(
      UserPostLoadEvent event, Emitter<ProfilePostsState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.getUserPosts(userId: event.userId);

      if (response.success) {
        final data = response.data as List<Post>;
        emit(state.copyWith(
          isLoading: false,
          userPosts: data,
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
  ProfilePostsState? fromJson(Map<String, dynamic> json) =>
      ProfilePostsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ProfilePostsState state) => state.toJson();
}
