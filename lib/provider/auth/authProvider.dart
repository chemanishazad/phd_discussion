import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/utils/service.dart';
import 'package:phd_discussion/models/auth/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    // Load user from SharedPreferences initially
    return await _loadUserFromPrefs();
  }

  Future<UserModel?> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      return UserModel(
        userId: prefs.getInt('userId')!,
        name: prefs.getString('name')!,
        email: prefs.getString('email')!,
        username: prefs.getString('username')!,
      );
    }
    return null;
  }

  Future<void> _saveUserToPrefs(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setInt('userId', user.userId);
    prefs.setString('name', user.name);
    prefs.setString('email', user.email);
    prefs.setString('username', user.username);
    prefs.setString('token', token);
  }

  Future<String> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the deviceToken from SharedPreferences
    String? deviceToken = prefs.getString('deviceToken');

    final response = await ApiMaster().fire(
      path: '/auth/login',
      method: HttpMethod.$post,
      auth: false,
      body: {
        'email': email,
        'password': password,
        'device_token': deviceToken,
      },
      contentType: ContentType.json,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['code'] == 200) {
        final user = UserModel.fromJson(data['userInfo']);
        final token = data['data']['token'];
        await _saveUserToPrefs(user, token);
        ApiMaster.setToken(token);
        state = AsyncData(user);
        return data['message'];
      } else {
        state = const AsyncData(null);
        return data['message'];
      }
    } else {
      state = const AsyncData(null);
      return 'Login failed. Please try again.';
    }
  }

  Future<void> logout() async {
    final response = await ApiMaster().fire(
      path: '/authentication/logout',
      method: HttpMethod.$get,
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      state = const AsyncData(null); // Clear user state
    }
  }
}
