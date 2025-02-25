import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/route/routes.dart';
import 'package:phd_discussion/core/theme/font/font_sizer.dart';
import 'package:phd_discussion/core/theme/theme.dart';
import 'package:phd_discussion/core/theme/theme_provider.dart';
import 'package:phd_discussion/core/utils/service.dart';
import 'package:phd_discussion/firebase_options.dart';
import 'package:phd_discussion/notification_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationServices.navigatorKey = navigatorKey;
  await NotificationServices.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await ApiMaster.loadToken();

  final deviceToken = await NotificationServices.getDeviceToken();
  print('Device Token: $deviceToken');

  final serverAccessToken = await NotificationServices.sendNotification();
  print('Server Access Token: $serverAccessToken');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final fontSize = ref.watch(fontSizeProvider);

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'PhD',
          themeMode: themeMode,
          theme: lightTheme(fontSize),
          darkTheme: darkTheme(fontSize),
          initialRoute: '/',
          routes: AppRoutes.routes,
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
