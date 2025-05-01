import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/constants/api_url.dart';

import 'core/app.dart';
import 'core/observers.dart';
import 'di/injector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;


void main() => runMain();

Future<void> runMain() async {
  //Đảm bảo tất cả các singleton được khởi tạo trước khi runApp.
  WidgetsFlutterBinding.ensureInitialized();
  await initSingletons();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initFCM();

  runApp(ProviderScope(
    observers: [
      Observers(),
    ],
    child: const MyApp(),
  ));
}

Future<void> initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    print("FCM Token: $token");

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('${ApiUrl.baseURL}/device-token'),
          headers: {'Content-Type': 'application/json'},
          body: '{"token": "$token"}',
        );

      } catch (e) {
        print('Error sending token: $e');
      }
    }
  } else {
    print("User declined or has not accepted permission");
  }

  // Lắng nghe khi có thông báo đến lúc app đang chạy
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message in foreground!');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
  });

  // Lắng nghe khi người dùng mở app từ notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('📲 User tapped the notification to open the app.');
  });
}

