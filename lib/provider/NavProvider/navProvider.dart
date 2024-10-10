import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/utils/service.dart';

import 'dropdownClass.dart';
import 'model/withoutLoginQuestionSave.dart';

final tagDropdownProvider = FutureProvider<List<Tag>>((ref) async {
  return getTagDropdown();
});
final categoriesDropdownProvider = FutureProvider<List<Category>>((ref) async {
  return getCategoriesDropdown();
});

Future<List<Tag>> getTagDropdown() async {
  try {
    final response = await ApiMaster().fire(
      path: '/getactivetagsandcategories',
      method: HttpMethod.$get,
      auth: false,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      if (data['tags'] is List) {
        final List<dynamic> tagsJson = data['tags'];
        return tagsJson.map<Tag>((tagJson) {
          return Tag.fromJson(tagJson);
        }).toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching user data: $e");
    rethrow;
  }
}

Future<List<Category>> getCategoriesDropdown() async {
  try {
    final response = await ApiMaster().fire(
      path: '/getactivetagsandcategories',
      method: HttpMethod.$get,
      auth: false,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      if (data['categories'] is List) {
        final List<dynamic> categoriesJson = data['categories'];
        return categoriesJson.map<Category>((categoryJson) {
          return Category.fromJson(categoryJson);
        }).toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching user data: $e");
    rethrow;
  }
}

Future<Map<String, dynamic>> postQuestionWithout(
    SaveQuestionWLogin saveQuestion) async {
  try {
    final response = await ApiMaster().fire(
      path: '/savequestionwithoutlogin',
      method: HttpMethod.$post,
      auth: false,
      body: saveQuestion,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Question saved successfully: $data");
      return data;
    } else {
      throw Exception('Failed to save question: ${response.body}');
    }
  } catch (e) {
    print("Error saving question: $e");
    rethrow;
  }
}
