part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.chats = const <Chat>[],
    this.isLoading = false,
    this.error = '',
    this.message = '',
  });

  final List<Chat> chats;
  final bool isLoading;
  final String error;
  final String message;

  ChatState copyWith({
    List<Chat>? chats,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return ChatState(
        chats: chats ?? this.chats,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        message: message ?? this.message);
  }

  const ChatState.empty() : this();

  factory ChatState.fromJson(Map<String, dynamic> json) => ChatState(
        chats: json['chats']
                ?.map<Chat>((x) => Chat.fromJson(x))
                ?.toList() ??
            <Chat>[],
      );

  Map<String, dynamic> toJson() => {
        'chats': chats.map((chat) => chat.toJson()).toList(),
      };

  @override
  List<Object> get props => [
        chats,
        isLoading,
        error,
        message,
      ];
}
