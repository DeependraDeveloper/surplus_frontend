import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.1, end: 1),
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: LottieBuilder.asset(
                  'assets/lotties/splash.json',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.done);
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
