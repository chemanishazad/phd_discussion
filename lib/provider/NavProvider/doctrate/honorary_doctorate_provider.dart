import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/utils/service2.dart';

final doctoratePageContent = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    Response response = await ApiMaster2().fire(
      path: '/honorary_doctorate/getDoctoratePagecontent',
      method: HttpMethod.$get,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return jsonData['data'];
    } else {
      throw Exception('Failed to fetch jobs');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
});

final submitInterestFormProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, String>>(
        (ref, params) async {
  final field = {
    'first_name': params['firstName'],
    'last_name': params['lastName'],
    'email': params['email'],
    'mobile': params['mobile'],
    'requirement_details': params['requirementDetails'],
  };

  try {
    Response response = await ApiMaster2().fire(
      path: '/honorary_doctorate/submitInterestForm',
      method: HttpMethod.$post,
      auth: true,
      body: field,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data;
      } else {
        throw data;
      }
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error loading users: ${e.toString()}');
  }
});
