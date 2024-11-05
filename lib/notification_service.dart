import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:phd_discussion/service.dart';

class NotificationServices {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static GlobalKey<NavigatorState>? navigatorKey;

  static const String notificationChannelId = 'RIM';
  static const int notificationId = 0;

  static Future<void> init() async {
    await Firebase.initializeApp();
    await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap);

    FirebaseMessaging.onMessage.listen(_handleIncomingNotification);
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => handleNotificationTapFromTerminated(message.data));

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationTapFromTerminated(initialMessage.data);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
    final payload = jsonEncode(message.data.isNotEmpty ? message.data : {});
    WidgetsFlutterBinding.ensureInitialized();
    await _showNotification(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      payload: payload,
    );
  }

  static Future<void> _showNotification(
      {required String title,
      required String body,
      required String? payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      notificationChannelId,
      'RIM',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@drawable/ic_notification',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
        notificationId, title, body, notificationDetails,
        payload: payload);
  }

  static void _handleIncomingNotification(RemoteMessage message) {
    final payload = message.data.isNotEmpty ? jsonEncode(message.data) : null;
    _showNotification(
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      payload: payload,
    );
  }

  static bool _isNavigating = false;

  static void handleNotificationTapFromTerminated(
      Map<String, dynamic> data) async {
    final route = data['route'] ?? '/bottomNavigation';
    final argumentsJson = data['arguments'] ?? '{}';
    final arguments = jsonDecode(argumentsJson) as Map<String, dynamic>;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey?.currentState?.context != null) {
        final context = navigatorKey!.currentState!.context;

        if (!_isNavigating && ModalRoute.of(context)?.settings.name != route) {
          _isNavigating = true;
          // Pass the decoded arguments to the route
          Navigator.of(context)
              .pushNamed(route, arguments: arguments)
              .then((_) {
            _isNavigating = false;
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/bottomNavigation', (Route<dynamic> route) => false);
          });
        }
      }
    });
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      _processNotificationPayload(payload);
    } else {
      print("No payload received");
    }
  }

  static void _processNotificationPayload(String payload) {
    if (_isNavigating) return;

    try {
      _isNavigating = true;
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final route = data['route'] ?? '/bottomNavigation';
      final argumentsJson = data['arguments'] is String
          ? data['arguments']
          : jsonEncode(data['arguments'] ?? {});
      final arguments = jsonDecode(argumentsJson) as Map<String, dynamic>;

      if (arguments.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey?.currentState?.context != null) {
            final context = navigatorKey!.currentState!.context;

            if (ModalRoute.of(context)?.settings.name != route) {
              Navigator.of(context)
                  .pushNamed(route, arguments: arguments)
                  .then((_) {
                _isNavigating = false;
              });
            } else {
              _isNavigating = false;
            }
          } else {
            print("Navigator context is not available");
            _isNavigating = false;
          }
        });
      } else {
        print("No valid arguments found in notification payload.");
        _isNavigating = false;
      }
    } catch (e) {
      print("Error parsing payload: $e");
      _isNavigating = false;
    }
  }

  static Future<String> getAccessToken() async {
    const serviceAccountJson = notificationService;

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    try {
      var client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
      var credentials = await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);
      client.close();
      return credentials.accessToken.data;
    } catch (e) {
      print('Error obtaining access credentials: $e');
      rethrow;
    }
  }

  static Future<String?> sendNotification() async {
    try {
      final String serverAccessToken = await getAccessToken();
      print('Server Access Token: $serverAccessToken');
      return serverAccessToken;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  static Future<String> getDeviceToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        return token;
      } else {
        throw Exception('Failed to get device token');
      }
    } catch (e) {
      print('Error getting device token: $e');
      rethrow;
    }
  }
}
