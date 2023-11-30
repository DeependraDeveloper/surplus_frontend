import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/bloc/location/location_bloc.dart';

import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';

class PostCard extends StatelessWidget {
  final String postId;
  final String title;
  final num distance;
  final String imagePath;
  final List<String> blessedBy;
  final String user;
  final bool isBlessed;

  const PostCard({
    Key? key,
    required this.postId,
    required this.title,
    required this.distance,
    required this.imagePath,
    required this.blessedBy,
    required this.user,
    required this.isBlessed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final distance = (this.distance / 1000);

    return Container(
      // height: 280,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepOrange.shade200,
            Colors.deepOrange.shade400,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: imagePath,
                errorWidget: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 30,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: const Color(0xFF2E2E2E),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${distance.toStringAsFixed(2)} Km away',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<PostBloc>(context).add(
                      BlessPostEvent(
                        postId: postId,
                        userId: user,
                      ),
                    );

                    BlocProvider.of<PostBloc>(context).add(
                      LoadPostsEvent(
                        refresh: false,
                        userId: user,
                        lat: context
                                .read<LocationBloc>()
                                .state
                                .position
                                ?.latitude ??
                            0,
                        long: context
                                .read<LocationBloc>()
                                .state
                                .position
                                ?.longitude ??
                            0,
                        range: context.read<PostBloc>().state.range,
                      ),
                    );

                    BlocProvider.of<ProfilePostsBloc>(context).add(
                      UserPostLoadEvent(userId: user),
                    );
                  },
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color:
                            isBlessed ? const Color(0xFFF15A29) : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: GoogleFonts.montserrat(
                            color: isBlessed
                                ? Colors.white
                                : const Color(0xFFF15A29),
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          child: Text(
                            isBlessed ? 'Blessed' : 'Bless',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
