import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/chat.dart';
import 'package:surplus/data/repositories/user_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends HydratedBloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.userBloc,
    required this.repository,
  }) : super(const ChatState.empty()) {
    on<LoadChatsEvent>(_onLoadChatsEvent);
    on<ConnectChatEvent>(_onConnectChatEvent);
  }

  final UserBloc userBloc;
  final UserRepository repository;

  FutureOr<void> _onLoadChatsEvent(
      LoadChatsEvent event, Emitter<ChatState> emit) async {
    if (event.refresh) {
      emit(const ChatState.empty());
    }

    emit(state.copyWith(isLoading: true, error: '', message: ''));

    try {
      final String userId = userBloc.state.user.id ?? '';

      final response = await repository.getChats(userId: userId);

      if (response.success) {
        final chats = response.data as List<Chat>;

        emit(state.copyWith(
          chats: chats,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  Future<FutureOr<void>> _onConnectChatEvent(
      ConnectChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoading: true, error: '', message: ''));

    try {
      final response = await repository.connectChat(
          from: event.from, post: event.post, to: event.to);

      if (response.success) {
        emit(state.copyWith(
          message: response.message,
          isLoading: false,
        ));

        add(const LoadChatsEvent());
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  @override
  ChatState? fromJson(Map<String, dynamic> json) => ChatState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ChatState state) => state.toJson();
}
