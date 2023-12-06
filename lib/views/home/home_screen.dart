// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/utils/notification_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final service = NotificationService();

  @override
  void initState() {
    super.initState();
    service.init();

    service.controller.stream.listen((event) {
      // context.read<PostBloc>().add(LoadPostsEvent(
      //     range: BlocProvider.of<PostBloc>(context).state.range));
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userId = context.read<UserBloc>().state.user.id ?? '';
    final double lat =
        context.read<LocationBloc>().state.position?.latitude ?? 0.0;
    final double long =
        context.read<LocationBloc>().state.position?.longitude ?? 0.0;
    final double range =
        context.watch<UserBloc>().state.user.range?.toDouble() ?? 5.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF15A29),
        elevation: 3,
        title: Text(
          'Blessings Near You',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        actions: [
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: () async {
                  final selectedRange = await showDialog<double>(
                    context: context,
                    builder: (context) {
                      return RangeSelectionDialog(initialRange: range);
                    },
                  );

                  if (selectedRange != null) {
                    context.read<PostBloc>().add(
                          LoadPostsEvent(
                            range: selectedRange,
                            lat: lat,
                            long: long,
                            userId: userId,
                          ),
                        );
                  }
                },
                icon: const Icon(
                  size: 30,
                  Icons.format_list_bulleted_rounded,
                  color: Colors.white,
                  weight: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        buildWhen: (p, c) {
          return p.posts != c.posts;
        },
        listener: (context, state) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }

          if (state.message.isNotEmpty) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(state.message),
            //   ),
            // );

            BlocProvider.of<PostBloc>(context).add(
              LoadPostsEvent(
                refresh: false,
                userId: context.read<UserBloc>().state.user.id ?? '',
                lat: context.read<LocationBloc>().state.position?.latitude ?? 0,
                long:
                    context.read<LocationBloc>().state.position?.longitude ?? 0,
                range: context.read<PostBloc>().state.range,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!state.isLoading && state.posts.isEmpty) {
            return const Center(
              child:
                  Text('No Blessings Found\n Try Changing the distance bounds'),
            );
          }

          if (state.posts.isNotEmpty == true) {
            return Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              child: RefreshIndicator(
                onRefresh: () {
                  context.read<PostBloc>().add(
                        LoadPostsEvent(
                          range: range,
                          lat: lat,
                          long: long,
                          userId: userId,
                        ),
                      );
                  return Future.value();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          final blessedBy = post.blessedBy ?? [];
                          final imagePath = post.images![0];
                          final title = post.title ?? '';
                          final postId = post.id ?? '';
                          final user = BlocProvider.of<UserBloc>(context)
                                  .state
                                  .user
                                  .id ??
                              '';
                          final distance = (post.dist!.calculated! / 1000);
                          final isBlessed = blessedBy.contains(user);

                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<PostBloc>()
                                  .add(GetPostEvent(postId: postId));
                              context.pushNamed('detail');
                            },
                            child: Container(
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
                                    Colors.deepOrange.shade400
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
                                        errorWidget:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.error,
                                          size: 30,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      title.toUpperCase(),
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        // color: Colors.white,
                                        color: const Color(0xFF2E2E2E),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${distance.toStringAsFixed(2)} Km away',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              BlocProvider.of<PostBloc>(context)
                                                  .add(
                                                BlessPostEvent(
                                                  postId: postId,
                                                  userId: user,
                                                ),
                                              );

                                              BlocProvider.of<ProfilePostsBloc>(
                                                      context)
                                                  .add(
                                                UserPostLoadEvent(userId: user),
                                              );
                                            },
                                            child: Material(
                                              elevation: 4,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Container(
                                                width: 100,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: isBlessed
                                                      ? const Color(0xFFF15A29)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.black),
                                                ),
                                                child: Center(
                                                  child:
                                                      AnimatedDefaultTextStyle(
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: isBlessed
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFFF15A29),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                    ),
                                                    child: Text(
                                                      isBlessed
                                                          ? 'Blessed'
                                                          : 'Bless',
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}

class RangeSelectionDialog extends StatefulWidget {
  const RangeSelectionDialog({
    Key? key,
    required this.initialRange,
  }) : super(key: key);

  final double initialRange;

  @override
  State<RangeSelectionDialog> createState() => _RangeSelectionDialogState();
}

class _RangeSelectionDialogState extends State<RangeSelectionDialog> {
  late int _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final String userId =
        BlocProvider.of<UserBloc>(context).state.user.id ?? '';
    final double lat =
        BlocProvider.of<LocationBloc>(context).state.position?.latitude ?? 0.0;
    final double long =
        BlocProvider.of<LocationBloc>(context).state.position?.longitude ?? 0.0;
    return AlertDialog(
      // backgroundColor: Colors.green[200],
      alignment: Alignment.center,
      title: const Text(
        'Add Distance Range',
      ),
      titleTextStyle: GoogleFonts.montserrat(
          fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
      icon: const Icon(
        Icons.directions_walk_rounded,
        size: 24,
        weight: 100,
        color: Colors.green,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFFF15A29),
                inactiveTrackColor: Colors.grey[300],
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 6.0, // Change the height of the slider track
                thumbColor: const Color(0xFFF15A29),
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10.0, // Change the size of the thumb
                ),
                overlayColor: const Color(0x29FF5722),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 10.0, // Change the size of the overlay
                ),
              ),
              child: Slider(
                value: _selectedRange.toDouble(),
                min: 1,
                max: 100,
                divisions: 50,
                label: '$_selectedRange km',
                onChanged: (value) {
                  setState(() {
                    _selectedRange = value.round();
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Selected Distance Range: $_selectedRange km',
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<PostBloc>().add(
                  LoadPostsEvent(
                    range: _selectedRange.toDouble(),
                    lat: lat,
                    long: long,
                    userId: userId,
                  ),
                );
            context.read<UserBloc>().add(GetUserEvent(userId: userId));
            context.pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
