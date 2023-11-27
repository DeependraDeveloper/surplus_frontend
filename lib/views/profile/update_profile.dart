import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/user.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key, required this.model});
  final User model;

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  XFile? _image;
  String modelImages = '';
  @override
  void initState() {
    nameController.text = widget.model.name ?? '';
    emailController.text = widget.model.email ?? '';
    phoneController.text = widget.model.phone ?? '';
    modelImages = widget.model.profilePic ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  Future<void> _pickImages() async {
    try {
      XFile? result =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = result;
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
          'UPDATE PROFILE',
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
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.message == 'Profile updated successfully!.') {
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
                        "Profile updated successfully!",
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
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Enter Name',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //  Description
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        labelText: 'Email',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Enter Email',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        labelText: 'Phone',
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        hintText: 'Enter Phone',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        border: const OutlineInputBorder(),
                      ),
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
                      child: _image?.name == ""
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
                              child: _image?.path.isEmpty ?? true
                                  ? (modelImages.isEmpty
                                      ? Container(
                                          height: 200,
                                          color: Colors
                                              .grey, // Placeholder for empty profile image
                                          child: const Center(
                                            child: Text(
                                              'Tap to add an image',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Image.network(
                                          modelImages)) // Display existing profile image
                                  : Image.file(File(
                                      _image!.path)), // Display selected image
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
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
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
                                context.read<UserBloc>().add(
                                      UpdateProfileEvent(
                                        userId: widget.model.id ?? '',
                                        email: emailController.text,
                                        name: nameController.text,
                                        phone: int.tryParse(
                                                phoneController.text) ??
                                            0,
                                        image: _image == null
                                            ? null
                                            : File(_image?.path ?? ''),
                                      ),
                                    );
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
