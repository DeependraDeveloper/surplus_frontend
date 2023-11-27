import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/profile_posts/profile_posts_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  final List<XFile> _images = [];

  Future<void> _pickImages(ImageSource source) async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? result;

      if (source == ImageSource.gallery) {
        result = await picker.pickImage(
          source: source,
          imageQuality: 10,
        );
      } else if (source == ImageSource.camera) {
        result = await picker.pickImage(
          source: source,
          imageQuality: 10,
        );
      }

      if (result != null) {
        setState(() {
          _images.add(result!);
        });
      }
    } catch (e) {
      debugPrint("Error From PickImages ========= ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF15A29),
        elevation: 3,
        title: Text(
          'DONATE FOR A CAUSE',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1
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
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state.error.isNotEmpty == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.error,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              );
            } else if (state.message.isNotEmpty == true) {
              BlocProvider.of<ProfilePostsBloc>(context).add(UserPostLoadEvent(
                userId: context.read<UserBloc>().state.user.id ?? '',
              ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green,
                        ),
                  ),
                ),
              );

              context.pushReplacement("/");
            }
          },
          builder: (context, state) {
            return Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        hintText: 'Enter Title',
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
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
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        labelText: 'Description',
                        labelStyle: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        hintText: 'Enter Description',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      "Upload image",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              elevation: 3,
                              title: Text(
                                "Select an option",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 21,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                    _pickImages(ImageSource
                                        .gallery); // Select from gallery
                                  },
                                  child: Text(
                                    "Gallery",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                    _pickImages(ImageSource
                                        .camera); // Capture from camera
                                  },
                                  child: Text(
                                    "Camera",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: _images.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              height: 150,
                              width: 365,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Text(
                                "Select Image",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(365, 10),
                                backgroundColor: const Color(0xFFF15A29),
                              ),
                              onPressed: () {
                                if (!_formkey.currentState!.validate()) {
                                  return;
                                }
                                if (_images.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please fill all the fields and add an image')),
                                  );
                                  return;
                                }

                                final double lat =
                                    BlocProvider.of<LocationBloc>(context)
                                            .state
                                            .position
                                            ?.latitude ??
                                        0.0;
                                final double long =
                                    BlocProvider.of<LocationBloc>(context)
                                            .state
                                            .position
                                            ?.longitude ??
                                        0.0;
                                final String userId =
                                    BlocProvider.of<UserBloc>(context)
                                            .state
                                            .user
                                            .id ??
                                        '';

                                context.read<PostBloc>().add(
                                      CreatePostEvent(
                                        userId: userId,
                                        title: titleController.text.trim(),
                                        description:
                                            descriptionController.text.trim(),
                                        images: _images,
                                        lat: lat,
                                        long: long,
                                      ),
                                    );
                              },
                              child: Text(
                                "Submit",
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
