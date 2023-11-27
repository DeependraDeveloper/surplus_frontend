// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/views/widgets/common_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final service = NotificationService();

  @override
  void initState() {
    // searchController = TextEditingController();
    super.initState();
    // service.init();

    // service.controller.stream.listen((event) {
    //   context.read<PostBloc>().add(LoadPostsEvent(
    //       range: BlocProvider.of<PostBloc>(context).state.range));
    // });
  }

  @override
  Widget build(BuildContext context) {
    final String userId =
        BlocProvider.of<UserBloc>(context).state.user.id ?? '';
    final double lat =
        BlocProvider.of<LocationBloc>(context).state.position?.latitude ?? 0.0;
    final double long =
        BlocProvider.of<LocationBloc>(context).state.position?.longitude ?? 0.0;
    final double range = context.watch<PostBloc>().state.range;

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
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
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                              context.pushNamed(
                                'detail',
                                extra: post,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.white38),
                                color: Colors.grey[300],
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    title.toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${distance.toStringAsFixed(2)} Km away',
                                        style: GoogleFonts.montserrat(
                                          color: const Color(0xFFF15A29),
                                          fontWeight: FontWeight.normal,
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

                                          BlocProvider.of<PostBloc>(context)
                                              .add(
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
                                              range: context
                                                  .read<PostBloc>()
                                                  .state
                                                  .range,
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
                                      )
                                    ],
                                  )
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
      title: Text(
        'Select Distance Range',
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
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
                trackHeight: 16.0, // Change the height of the slider track
                thumbColor: const Color(0xFFF15A29),
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 14.0, // Change the size of the thumb
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
          Text(
            'Selected Distance Range: $_selectedRange km',
            style: GoogleFonts.montserrat(
              color: const Color(0xFFF15A29),
              fontSize: 12,
              fontWeight: FontWeight.w700,
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
            context.pop(); // Return the selected range on OK press
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
