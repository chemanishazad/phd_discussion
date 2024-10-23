import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phd_discussion/core/utils/service.dart';
import 'package:phd_discussion/models/auth/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    return await _loadUserFromPrefs();
  }

  Future<UserModel?> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      return UserModel(
        userId: prefs.getString('userId')!,
        name: prefs.getString('name')!,
        email: prefs.getString('email')!,
        username: prefs.getString('username')!,
        authToken: prefs.getString('token')!,
      );
    }
    return null;
  }

  Future<void> _saveUserToPrefs(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', user.userId);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('username', user.username);
    await prefs.setString('token', token);
  }

  Future<String> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
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
      print('body$data');
      if (data['status'] == true) {
        final user = UserModel(
          userId: data['data']['user_id'],
          name: data['data']['username'],
          email: email,
          username: data['data']['username'],
          authToken: data['data']['token'],
        );
        final token = data['data']['token'];
        await _saveUserToPrefs(user, token);
        ApiMaster.setToken(token);
        state = AsyncData(user); // Notify listeners

        print('User logged in: ${user.name}');
        return data['message'];
      } else {
        state = const AsyncData(null);
        print('Login failed: ${data['message']}');
        return data['message'] ?? 'Unknown error occurred.';
      }
    } else {
      state = const AsyncData(null);
      print('HTTP error: ${response.statusCode}');
      return 'Login failed. Please try again.';
    }
  }

  Future<String> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
    String mobile,
    String designation,
    List<String> areaOfInterest,
  ) async {
    final response = await ApiMaster().fire(
      path: '/auth/signup',
      method: HttpMethod.$post,
      auth: false,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
        'mobile': mobile,
        'designation': designation,
        'area_of_interest': areaOfInterest,
      },
      contentType: ContentType.json,
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      print('data$data');
      return data['message'];
    } else {
      final data = json.decode(response.body);
      print('data$data');
      return data['message'] ?? 'Login failed. Please try again.';
    }
  }

  Future<void> logout() async {
    final response = await ApiMaster().fire(
      path: '/logout',
      auth: false,
      method: HttpMethod.$post,
    );

    final data = json.decode(response.body);
    print(data);

    if (response.statusCode == 200 || response.statusCode == 403) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userId');
      await prefs.remove('name');
      await prefs.remove('email');
      await prefs.remove('username');
      await prefs.remove('token');

      state = const AsyncData(null);
      Fluttertoast.showToast(msg: 'Logout Success');
    }
  }
}
