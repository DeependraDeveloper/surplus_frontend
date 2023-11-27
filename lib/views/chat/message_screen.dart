import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/bloc/chat/chat_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/chat.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF15A29),
        elevation: 3,
        title: Text(
          'CHATS',
          style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Divider(
              height: 2,
              color: Color.fromARGB(139, 0, 0, 0),
            ),
          ),
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (BuildContext context, state) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (BuildContext context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.isLoading && state.chats.isEmpty) {
            return const Center(
              child: Text('No Chats Found.'),
            );
          }

          if (state.chats.isNotEmpty == true) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: ListView.builder(
                // separatorBuilder: (context, index) => const Divider(
                //   color: Colors.red,
                // ),
                itemCount: state.chats.length,
                itemBuilder: (context, index) {
                  final Chat chat = state.chats[index];
                  final int msgIdx = chat.messages?.length ?? 0;

                  var profilePic = '';
                  var name = '';

                  final String userId =
                      BlocProvider.of<UserBloc>(context).state.user.id ?? '';

                  if (chat.to?.id == userId) {
                    profilePic = chat.from?.profilePic ?? '';
                    name = chat.from?.name ?? '';
                  } else {
                    profilePic = chat.to?.profilePic ?? '';
                    name = chat.to?.name ?? '';
                  }

                  return ListTile(
                    tileColor: const Color.fromARGB(206, 241, 221, 221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    onTap: () {
                      context.pushNamed('chat', extra: chat);
                    },
                    dense: true,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePic),
                    ),
                    title: Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      chat.messages?.isNotEmpty == true && msgIdx > 0
                          ? chat.messages![msgIdx - 1].content != null &&
                                  chat.messages![msgIdx - 1].content!
                                      .startsWith('https://')
                              ? '...'
                              : chat.messages![msgIdx - 1].content ?? ''
                          : 'No messages yet',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
