import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/bloc/chat/chat_bloc.dart';
// import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/chat.dart';
import 'package:surplus/data/models/post.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({
    super.key,
    // required this.post,
  });
  // final Post post;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    // final Post post = widget.post;
    // final String imagePath = widget.post.images?[0] ?? '';
    // var distance = ((post.dist?.calculated ?? 0) / 1000);

    // bool isBlessed = false;
    // final String user = BlocProvider.of<UserBloc>(context).state.user.id ?? '';
    // if (widget.post.blessedBy!.contains(user)) isBlessed = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BLESSING DETAILS',
          style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF15A29),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2), // Adjust the height of the line
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Divider(
              height: 2,
              color: Color.fromARGB(139, 0, 0, 0),
            ),
          ),
        ),
      ),
      body: BlocConsumer<PostBloc, PostState>(
        buildWhen: (p, c) {
          return p.post != c.post;
        },
        listener: (context, state) {
          if (state.message.isNotEmpty) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //   ),
            // );

            BlocProvider.of<PostBloc>(context).add(
              GetPostEvent(postId: state.post!.id ?? ''),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.post == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.isLoading && state.post == null) {
            return const Center(
              child:
                  Text('No Blessings Found\n Try Changing the distance bounds'),
            );
          }

          if (state.post != null) {
            final Post post = state.post!;
            final String imagePath = post.images?[0] ?? '';
            var distance = ((post.dist?.calculated ?? 0) / 1000);

            bool isBlessed = false;
            final String user =
                BlocProvider.of<UserBloc>(context).state.user.id ?? '';
            if (post.blessedBy!.contains(user)) isBlessed = true;

            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                clipBehavior: Clip.antiAlias,
                                insetPadding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8, // Adjust width as needed
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: InteractiveViewer(
                                    // boundaryMargin: const EdgeInsets.all(20.0),
                                    minScale: 0.5,
                                    maxScale: 2.5,
                                    child: Hero(
                                      tag: 'imageHero',
                                      child: Image.network(
                                        imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Image.network(
                          imagePath,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${distance.toStringAsFixed(2)} kms away.',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFF15A29),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.social_distance,
                        color: Color(0xFFF15A29),
                        size: 34,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${post.title?.toUpperCase() ?? ""}.',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    '${post.description ?? ""}.',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<PostBloc>(context).add(
                        BlessPostEvent(
                          postId: post.id ?? '',
                          userId: user,
                        ),
                      );
                    },
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isBlessed
                              ? const Color(0xFFF15A29)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            isBlessed ? 'Blessed' : 'Bless',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              color: isBlessed
                                  ? Colors.white
                                  : const Color(0xFFF15A29),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(365, 10),
                      backgroundColor: const Color(0xFFF15A29),
                    ),
                    onPressed: () {
                      final String from =
                          BlocProvider.of<UserBloc>(context).state.user.id ??
                              '';

                      BlocProvider.of<ChatBloc>(context).add(
                        ConnectChatEvent(
                          from: from,
                          post: post.id ?? '',
                          to: post.userId ?? '',
                        ),
                      );

                      final chats =
                          BlocProvider.of<ChatBloc>(context).state.chats;

                      // in list of chat , find chat where to belongs to post.userId and pass the chat below
                      final chat = chats.firstWhere(
                        (chat) {
                          return chat.to?.id == post.userId ||
                              chat.from?.id == post.userId;
                        },
                        orElse: () => Chat(),
                      );

                      context.pushNamed('chat', extra: chat);
                    },
                    child: Text(
                      "Connect",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
