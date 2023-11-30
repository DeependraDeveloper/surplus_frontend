import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:surplus/views/loading_screen.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.network(
                'https://lottie.host/2554a005-b3e5-4839-9bc9-242faa7d2970/iTzPK7U9Iz.json',
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
              Text(
                'No internet connection!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your internet connection and try again.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              const Loading(
                event: 'Trying to reconnect...',
              )
            ],
          ),
        ),
      ),
    );
  }
}
