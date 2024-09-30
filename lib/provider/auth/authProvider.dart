import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phd_discussion/core/utils/service.dart';
import 'package:phd_discussion/models/auth/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  UserModel? _user;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      _user = UserModel(
        userId: prefs.getInt('userId')!,
        name: prefs.getString('name')!,
        email: prefs.getString('email')!,
        username: prefs.getString('username')!,
      );
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', _isLoggedIn);
    prefs.setInt('userId', _user!.userId);
    prefs.setString('name', _user!.name);
    prefs.setString('email', _user!.email);
    prefs.setString('username', _user!.username);
  }

  Future<String> login(String email, String password) async {
    final response = await ApiMaster().fire(
      path: '/auth/login',
      method: HttpMethod.$post,
      auth: false,
      body: {
        'email': email,
        'password': password,
      },
      contentType: ContentType.formData,
    );

    // Print the response for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body.toString()}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['code'] == 200) {
        _isLoggedIn = true;
        _user = UserModel.fromJson(data['userInfo']);
        await _saveUserToPrefs();
        notifyListeners();
        return data['message'];
      } else {
        _isLoggedIn = false;
        _user = null;
        notifyListeners();
        return data['message'];
      }
    } else {
      _isLoggedIn = false;
      _user = null;
      notifyListeners();
      return 'Login failed. Please try again.';
    }
  }

  Future<void> logout() async {
    final response = await ApiMaster().fire(
      path: '/authentication/logout',
      method: HttpMethod.$get,
    );
    try {
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        _isLoggedIn = false;
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      throw e.toString;
    }
  }
}
