import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/post.dart';

class UpdatePostScreen extends StatefulWidget {
  const UpdatePostScreen({super.key, required this.model});
  final Post model;

  @override
  State<UpdatePostScreen> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePostScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<XFile> _images = [];
  List<String> modelImages = [];
  @override
  void initState() {
    titleController.text = widget.model.title ?? '';
    descriptionController.text = widget.model.description ?? '';
    modelImages = widget.model.images ?? [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> _pickImages() async {
    try {
      List<XFile>? result =
          await ImagePicker().pickMultiImage(imageQuality: 10);
      setState(() {
        _images = result;
      });
    } catch (e) {
      debugPrint("Error From PickImages ========= ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Post',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFFF15A29),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state.message == 'Post Updated Successfully!.') {
              context.read<ProfilePostsBloc>().add(
                    UserPostLoadEvent(
                        userId:
                            BlocProvider.of<UserBloc>(context).state.user.id ??
                                ''),
                  );
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        size: 48,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Post has been Updated succesfull",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        while (context.canPop()) {
                          context.pop();
                        }
                      },
                      child: Text(
                        "OK",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    //  title
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Enter Title',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    //  Description
                    TextFormField(
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        labelText: 'Description',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Enter Description',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Upload image",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImages,
                      child: _images.isEmpty
                          ? SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: modelImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Image.network(modelImages[index]),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              _pickImages();
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: const Icon(Icons.edit),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Image.file(File(_images[index].path)),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _images.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: const Icon(Icons.close),
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

                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF15A29),
                              ),
                              onPressed: () {
                                if (!_formkey.currentState!.validate()) {
                                  return;
                                }

                                context.read<PostBloc>().add(UpdatePostEvent(
                                      id: widget.model.id ?? '',
                                      title: titleController.text.trim(),
                                      description:
                                          descriptionController.text.trim(),
                                      images: _images,
                                    ));
                              },
                              child: Text(
                                "Update",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
