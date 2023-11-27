import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/repositories/user_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends HydratedBloc<PostEvent, PostState> {
  PostBloc({
    required this.repository,
  }) : super(const PostState()) {
    on<LoadPostsEvent>(_onLoadPostsEvent);
    on<CreatePostEvent>(_onCreatePostEvent);
    on<UpdatePostEvent>(_onUpdatePostEvent);
    on<SearchPostEvent>(_onSearchPostEvent);
    on<BlessPostEvent>(_onBlessPostEvent);
    on<GetPostEvent>(_onGetPostEvent);
  }
  final UserRepository repository;

  FutureOr<void> _onLoadPostsEvent(
      LoadPostsEvent event, Emitter<PostState> emit) async {
    if (event.refresh) {
      emit(const PostState.empty());
    }
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.posts(
        lat: event.lat,
        long: event.long,
        userId: event.userId,
        range: event.range,
      );

      if (response.success) {
        final posts = response.data as List<Post>;

        emit(state.copyWith(
            posts: posts, isLoading: false, range: event.range.toDouble()));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  FutureOr<void> _onCreatePostEvent(
      CreatePostEvent event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.createPost(
        event.userId,
        event.title,
        event.description,
        event.images.map((xFile) => File(xFile.path)).toList(),
        event.lat,
        event.long,
      );

      if (response.success) {
        emit(state.copyWith(
          message: response.message,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          error: response.message,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> _onUpdatePostEvent(
      UpdatePostEvent event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.updatePost(
        event.id,
        event.title,
        event.description,
        event.images.map((xFile) => File(xFile.path)).toList(),
      );
      if (response.success) {
        emit(state.copyWith(
          message: response.message,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          error: response.message,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> _onSearchPostEvent(
      SearchPostEvent event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.searchPost(
          event.name, event.userId, event.lat, event.long);

      if (response.success) {
        final posts = response.data as List<Post>;

        emit(state.copyWith(
          searchedPosts: posts,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onBlessPostEvent(
      BlessPostEvent event, Emitter<PostState> emit) async {
    try {
      final response = await repository.blessPost(
        postId: event.postId,
        userId: event.userId,
      );

      if (response.success) {
        emit(state.copyWith(
          isLoading: false,
          message: response.message,
        ));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<FutureOr<void>> _onGetPostEvent(
      GetPostEvent event, Emitter<PostState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));
    try {
      final response = await repository.getPost(postId: event.postId);

      if (response.success) {
        final post = response.data as Post;

        emit(state.copyWith(
          post: post,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  @override
  PostState? fromJson(Map<String, dynamic> json) => PostState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(PostState state) => state.toJson();
}
