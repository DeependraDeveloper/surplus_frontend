part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChatsEvent extends ChatEvent {
  const LoadChatsEvent({this.refresh = false});

  final bool refresh;

  @override
  List<Object> get props => [refresh];
}

class ConnectChatEvent extends ChatEvent {
  const ConnectChatEvent({
    required this.from,
    required this.post,
    required this.to,
  });

  final String from;
  final String post;
  final String to;

  @override
  List<Object> get props => [from, post, to];
}
