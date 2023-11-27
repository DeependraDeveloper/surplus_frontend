// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/bloc/friend/friend_posts_bloc.dart';
import 'package:surplus/data/models/post.dart';
import 'package:surplus/data/models/user.dart';

class FriendProfile extends StatefulWidget {
  const FriendProfile({super.key, required this.friend});

  final User friend;
  @override
  State<FriendProfile> createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendPostsBloc, FriendPostsState>(
      builder: (context, state) {
        final userPosts = state.friendPosts;
        int blesses = 0;

        for (final post in userPosts) {
          if (post.blessedBy != null) {
            blesses += post.blessedBy?.length ?? 0;
          }
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF15A29),
            elevation: 3,
            title: Text(
              "Blesser Profile",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                            letterSpacing: 1

              ),
            ),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize:
                  Size.fromHeight(2), // Adjust the height of the line
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Divider(
                  height: 2,
                  color: Color.fromARGB(139, 0, 0, 0),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    maxRadius: 70,
                    backgroundImage:
                        NetworkImage(widget.friend.profilePic ?? ''),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '${widget.friend.name}',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 325,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF15A29),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.local_activity_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        'Blessed by $blesses people so far.',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (userPosts.isEmpty)
                  Center(
                    child: Text(
                      'No Blessings Add Yet',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: userPosts.length,
                        itemBuilder: (context, index) {
                          final Post post = userPosts[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(post.images?[0] ?? ''),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                          0.6), // Semi-transparent black background
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${post.title?.toUpperCase()}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
