// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surplus/firebase_options.dart';
import 'package:surplus/utils/bloc_observer.dart';

Future<void> startApplication(FutureOr<Widget> Function() builder) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );

    /// user bloc observer to observe the state changes in the blocs
    Bloc.observer = AppBlocObserver();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// import fcm
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // print('token: $token');

    /// request permission
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  } catch (_) {
    // print('There is some error in initializing the application (: : $_');
  }
  final app = await builder();
  runApp(app);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // print('Handling a background message ${message.messageId}');
}
