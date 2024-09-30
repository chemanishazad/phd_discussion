import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/utils/service.dart';
import 'package:phd_discussion/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthModel {
  final String token;
  AuthModel({required this.token});
}

class AuthProvider extends StateNotifier<AuthModel?> {
  AuthProvider() : super(null) {
    loadUserFromPrefs();
  }

  bool get isLoggedIn => state != null;

  Future<void> _saveUserToPrefs(AuthModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('token', user.token);
    ApiMaster.setToken(user.token);
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final token = prefs.getString('token');
      if (token != null) {
        state = AuthModel(token: token);
        ApiMaster.setToken(token);
      } else {
        state = null;
      }
    } else {
      state = null;
    }
  }

  Future<void> login(
      String username, String password, String deviceToken) async {
    try {
      final response = await ApiMaster().fire(
        path: '/auth/login',
        method: HttpMethod.$post,
        auth: false,
        contentType: ContentType.formData,
        body: {
          'email': username,
          'password': password,
          'device_token': deviceToken
        },
      );

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        ApiMaster.setToken(token);

        final user = AuthModel(token: token);
        await _saveUserToPrefs(user);
        state = user;
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  Future<void> logout() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    ApiMaster.clearToken();
    state = null;
    _notifyAppOfLogout();
  }

  void _notifyAppOfLogout() {
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!)
          .pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthProvider, AuthModel?>((ref) => AuthProvider());
