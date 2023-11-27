// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF15A29),
        elevation: 0,
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 2 / 3,
              decoration: const BoxDecoration(
                color: Color(0xFFF15A29),
              ),
            ),
          ),
          SvgPicture.asset(
            'assets/svgs/surplus_logo.svg',
          ),
          const SizedBox(
            height: 20,
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () async {
              context.pushReplacement('/login');
            },
          ),
        ],
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 150); // Bottom-left corner
    path.quadraticBezierTo(size.width / 2, size.height, size.width,
        size.height - 150); // Bottom-right corner
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
