import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/utils/service.dart';

Future<Map<String, dynamic>> getProfile() async {
  try {
    final response = await ApiMaster().fire(
      path: '/userdetails',
      method: HttpMethod.$get,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching profile: $e");
    throw Exception("Error fetching profile: $e");
  }
}

Future<Map<String, dynamic>> getTag() async {
  try {
    final response = await ApiMaster().fire(
      path: '/gettags',
      method: HttpMethod.$get,
      auth: false,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching user data: $e");
    rethrow;
  }
}

Future<Response> updateTag(List<int> tags) async {
  try {
    final response = await ApiMaster().fire(
      path: '/addinteresttags',
      method: HttpMethod.$post,
      body: {
        'tags': tags,
      },
      contentType: ContentType.json,
    );

    if (kDebugMode) {
      print('Post Answer Response Status Code: ${response.statusCode}');
      print('Post Answer Response Body: ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to post answer: ${response.statusCode} - ${response.body}');
    }

    return response;
  } catch (e) {
    print('Error during postAnswer: $e');
    throw Exception("Failed to post answer: ${e.toString()}");
  }
}

Future<Response> updateProfile(
  String name,
  String mobile,
  String about,
  String researchDetail,
) async {
  try {
    final response = await ApiMaster().fire(
      path: '/updateprofile',
      method: HttpMethod.$post,
      body: {
        'name': name,
        'mobile': mobile,
        'about': about,
        'research_detail': researchDetail,
      },
      contentType: ContentType.json,
    );

    if (kDebugMode) {
      print('Post Answer Response Status Code: ${response.statusCode}');
      print('Post Answer Response Body: ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to post answer: ${response.statusCode} - ${response.body}');
    }

    return response;
  } catch (e) {
    print('Error during postAnswer: $e');
    throw Exception("Failed to post answer: ${e.toString()}");
  }
}
