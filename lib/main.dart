import 'package:flutter/material.dart';
import 'package:phd_discussion/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:phd_discussion/provider/auth/authProvider.dart';
import 'package:phd_discussion/core/theme/theme.dart';
import 'package:phd_discussion/core/route/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'PhD',
          themeMode: themeProvider.themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          initialRoute: '/',
          routes: AppRoutes.routes,
          navigatorKey: navigatorKey,
        );
      },
    );
  }
}
