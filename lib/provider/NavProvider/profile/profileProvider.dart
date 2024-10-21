import 'dart:convert';

import 'package:phd_discussion/core/utils/service.dart';

Future<Map<String, dynamic>> getProfile() async {
  try {
    final response = await ApiMaster().fire(
      path: '/userdetails',
      method: HttpMethod.$get,
      auth: true,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to fetch categories: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching categories: $e");
    rethrow;
  }
}
