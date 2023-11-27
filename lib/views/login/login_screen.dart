// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/post/post_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) async {
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
            context.read<PostBloc>().add(LoadPostsEvent(
                  range:
                      context.read<UserBloc>().state.user.range?.toDouble() ??
                          5.0,
                  userId: state.user.id ?? '',
                  lat: context.read<LocationBloc>().state.position?.latitude ??
                      0,
                  long:
                      context.read<LocationBloc>().state.position?.longitude ??
                          0,
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
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/surplus_logo.svg',
                        height: 54,
                        width: 54,
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Form(
                        key: formKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: phoneController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.phone,
                                autofillHints: const [
                                  AutofillHints.telephoneNumber
                                ],
                                decoration: InputDecoration(
                                  hoverColor: Colors.black,
                                  prefixIcon: const Icon(Icons.phone,
                                      color: Colors.black),
                                  focusColor: Colors.black,
                                  labelText: 'Phone Number',
                                  labelStyle: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFFF15A29),
                                    ), // Set the border color when focused
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    // Set the border color when not focused
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid  phone number';
                                  } else if (value.length <= 9) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                  hoverColor: Colors.black,
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                  focusColor: Colors.black,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFF15A29)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(
                                      () => isObscure = !isObscure,
                                    ),
                                    icon: Icon(
                                      isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Store password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24.0),
                              state.isLoading
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF15A29),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        minimumSize: const Size(150, 50),
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState?.validate() ==
                                            true) {
                                          context.read<UserBloc>().add(
                                                SignInEvent(
                                                  phone: int.parse(
                                                      phoneController.text
                                                          .trim()),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                  lat: BlocProvider.of<
                                                                  LocationBloc>(
                                                              context)
                                                          .state
                                                          .position
                                                          ?.latitude ??
                                                      0.0,
                                                  long: BlocProvider.of<
                                                                  LocationBloc>(
                                                              context)
                                                          .state
                                                          .position
                                                          ?.longitude ??
                                                      0.0,
                                                ),
                                              );
                                        } else {
                                          final errorMessage = context
                                              .read<UserBloc>()
                                              .state
                                              .message;
                                          if (errorMessage.isNotEmpty) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                errorMessage,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Forgot Password?',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              context.pushNamed('reset_password');
                            },
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFFF15A29),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              context.pushNamed('signUp');
                            },
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.montserrat(
                                color: const Color(0xFFF15A29),
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
