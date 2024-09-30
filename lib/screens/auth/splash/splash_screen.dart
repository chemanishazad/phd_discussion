import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/notification_service.dart';
import 'package:phd_discussion/provider/authProvider/authProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    await Future.delayed(const Duration(seconds: 1));
    await ref.read(authProvider.notifier).loadUserFromPrefs();

    final authState = ref.read(authProvider);
    print('Auth state after loading: $authState');

    String? deviceToken = await NotificationServices.getDeviceToken();
    print('Device token: $deviceToken');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (deviceToken != null) {
      await prefs.setString('deviceToken', deviceToken);
    }
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      NotificationServices.handleNotificationTapFromTerminated(
          initialMessage.data);
    } else {
      Navigator.pushNamed(context, '/onBoard');
      // if (authState == null) {
      //   print('Navigating to login');
      //   Navigator.pushNamed(context, '/login');
      // } else {
      //   print('Navigating to home');
      //   Navigator.pushNamed(context, '/bottomNavigation');
      // }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/icons/logo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
