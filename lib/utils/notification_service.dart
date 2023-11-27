import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

// The NotificationService class is responsible for handling notifications using the Firebase Cloud Messaging (FCM) package. It sets up a stream to listen for incoming messages and processes them accordingly.
class NotificationService {
  // a broadcast stream controller that will be used to broadcast RemoteMessage objects.
  final StreamController<RemoteMessage> controller =
      StreamController<RemoteMessage>.broadcast();

  //  method initializes the notification service. It requests permission for notifications, and sets up handlers for foreground, background, and terminated notifications.
  void init() {
    requestPermission().then(
      (status) {
        forgroundNotification(); // forground notification
        backgroundNotification(); // background notification
        terminateNotification(); // terminate notification
      },
    );
  }

  /*
  request permission for ios and android
  The NotificationService sets up handlers and listeners for different notification events, including scenarios where the user may revoke the permissions later.
  For example, if the user cancels notification permissions from the app info, the NotificationService will still be able to handle incoming messages in the background using the terminateNotification method.
  So, in summary, the NotificationService provides a layer of handling for notifications that goes beyond the initial permission request,
  ensuring that your app can still respond to notifications even if the user modifies their permissions after the app has started.
  */
  Future<bool> requestPermission() async {
    try {
      final messaging = FirebaseMessaging.instance;

      if (!(await messaging.isSupported())) return false;
      // print('Notification : Supported Checked confiming Permission!');
      final permission = await messaging.requestPermission();
      // print('Notification : Permission Requested!');

      /// setting up firebase messaging mainly for receiving notification in foreground ios
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (permission.authorizationStatus == AuthorizationStatus.authorized) {
        // print('Notification : Permission Granted!');
        return true;
      } else if (permission.authorizationStatus ==
          AuthorizationStatus.provisional) {
        // print('Notification : Provisional Permission Granted!');
        return true;
      } else if (permission.authorizationStatus ==
          AuthorizationStatus.notDetermined) {
        // print('Notification : Permission Not Granted!');
        await messaging.requestPermission();
        return false;
      }
      return false;
    } on Exception catch (_) {
      throw Exception('Notification : Error Occured!');
    }
  }

  //  method sets up a listener for foreground notifications. When a message is received in the foreground, it adds the message to the stream controller.
  void forgroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.notification != null) {
          controller.add(message);
        }
      },
      onError: (error) {
        controller.addError(error);
      },
    );
  }

  //  method sets up a listener for notifications that are received when the app is in the background and is opened by tapping the notification. It also adds the message to the stream controller.
  void backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (message.notification != null) {
          controller.add(message);
        }
      },
      onError: (error) {
        controller.addError(error);
      },
    );
  }

  // method handles notifications received when the app was terminated. It checks if there is an initial message and adds it to the stream controller.
  void terminateNotification() async {
    try {
      RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        if (message.notification != null) {
          controller.add(message);
        }
      }
    } on Exception catch (e) {
      controller.addError(e);
    }
  }
}
