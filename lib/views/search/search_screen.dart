import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/views/widgets/common_widgets.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userId =
        BlocProvider.of<UserBloc>(context).state.user.id ?? '';

    final double lat =
        BlocProvider.of<LocationBloc>(context).state.position?.latitude ?? 0.0;
    final double long =
        BlocProvider.of<LocationBloc>(context).state.position?.longitude ?? 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF15A29),
        elevation: 3,
        title: Text(
          'SEARCH BLESSINGS',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Search for blessings...',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (String value) {
                        context.read<PostBloc>().add(
                              SearchPostEvent(
                                name: _searchController.text.trim(),
                                userId: userId,
                                lat: lat,
                                long: long,
                              ),
                            );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PostBloc>().add(
                            SearchPostEvent(
                              name: _searchController.text.trim(),
                              userId: userId,
                              lat: lat,
                              long: long,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF15A29),
                    ),
                    child: Text(
                      'Search',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<PostBloc, PostState>(
              builder: (BuildContext context, PostState state) {
                final loading = state.isLoading;
                final posts = state.searchedPosts;
                if (!loading && posts.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Find any available blessings Near you😃\nIf No Blessings Found Near You\nPlease try to come back later 🥺.',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                } else if (loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!loading && posts.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        var post = posts[index];
                        return GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              'detail',
                              extra: post,
                            );
                          },
                          child: PostCard(
                            user: context.read<UserBloc>().state.user.id ?? '',
                            isBlessed: false,
                            postId: post.id ?? '',
                            blessedBy: post.blessedBy ?? [],
                            distance: post.dist?.calculated ?? 0,
                            imagePath: post.images?.isNotEmpty == true
                                ? post.images![0]
                                : '',
                            title: post.title ?? '',
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('Find any available blessings\nNear you 😃.'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
