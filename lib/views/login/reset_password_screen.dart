import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnteredPasswordController = TextEditingController();

  bool isObscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    reEnteredPasswordController.dispose();
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
            context.pop();

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
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
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
                              TextFormField(
                                controller: reEnteredPasswordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                  hoverColor: Colors.black,
                                  labelText: 'Re Enter Password',
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
                                    // Set the border color when not focused
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
                                  ? const SizedBox()
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
                                      onPressed: () async {
                                        if (formKey.currentState?.validate() ==
                                            true) {
                                          context.read<UserBloc>().add(
                                                ResetPasswordEvent(
                                                  phone: int.parse(
                                                      phoneController.text
                                                          .trim()),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                  reEnteredpassword:
                                                      reEnteredPasswordController
                                                          .text
                                                          .trim(),
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
                                        'Reset Password',
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
