import 'dart:convert';

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
// Future<Map<String, dynamic>> getCategories() async {
//   try {
//     final response = await ApiMaster().fire(
//       path: '/getcategories',
//       method: HttpMethod.$get,
//       auth: false,
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       print(data);
//       return data;
//     } else {
//       throw Exception('Failed to fetch user data: ${response.statusCode}');
//     }
//   } catch (e) {
//     print("Error fetching user data: $e");
//     rethrow;
//   }
// }
