// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:surplus/bloc/auth/authentication_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/post.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePostsBloc, ProfilePostsState>(
      builder: (context, state) {
        final user = context.read<UserBloc>().state.user;
        final userPosts = state.userPosts;

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
              "PROFILE",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                color: Colors.white,
                iconSize: 30,
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await HydratedBloc.storage.clear();
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationUnAuthenticated());

                  context.read<UserBloc>().add(ClearUser());
                },
              ),
            ],
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
                  child: GestureDetector(
                    onTap: () {
                      context.goNamed('editProfile', extra: user);
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          maxRadius: 70,
                          backgroundImage: NetworkImage(user.profilePic ?? ''),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -7,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 40,
                              color: Color(
                                0xFFF15A29,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '${user.name}',
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
                        size: 30,
                        Icons.auto_awesome_sharp,
                        color: Colors.black,
                      ),
                      Text(
                        'Blessed by $blesses people so far.',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 21,
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
                          return GestureDetector(
                            onTap: () {
                              context.goNamed('updatePost', extra: post);
                            },
                            child: Container(
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
                                        color: Colors.transparent,
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
