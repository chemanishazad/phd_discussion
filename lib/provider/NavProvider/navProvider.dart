import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/utils/service.dart';
import 'package:phd_discussion/provider/NavProvider/model/editQuestionApiModel.dart';
import 'package:phd_discussion/provider/NavProvider/model/withLoginQuestionSave.dart';

import 'dropdownClass.dart';
import 'model/withoutLoginQuestionSave.dart';

final tagProvider = FutureProvider<List<Tag>>((ref) async {
  return getTag();
});

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

Future<List<Tag>> getTag() async {
  try {
    final response = await ApiMaster().fire(
      path: '/gettags',
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

Future<Map<String, dynamic>> getCategories() async {
  try {
    final response = await ApiMaster().fire(
      path: '/getcategories',
      method: HttpMethod.$get,
      auth: false,
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

Future<Map<String, dynamic>> editQuestion(EditQuestionModel question) async {
  try {
    final response = await ApiMaster().fire(
      path: '/editquestion',
      method: HttpMethod.$post,
      auth: true,
      body: question,
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

Future<Map<String, dynamic>> postQuestionWith(
    SaveQuestionWithLogin saveQuestion) async {
  try {
    final response = await ApiMaster().fire(
      path: '/savequestionwithlogin',
      method: HttpMethod.$post,
      auth: true,
      body: saveQuestion,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Question saved successfully: $data");
      return data;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Failed to save question: $data");
      return data;
    } else {
      throw Exception('Failed to save question: ${response.body}');
    }
  } catch (e) {
    print("Error saving question: $e");
    rethrow;
  }
}

Future<Map<String, dynamic>> submitHelp(
    String issueType, String comments) async {
  final response = await ApiMaster().fire(
    path: '/saveenquiry',
    method: HttpMethod.$post,
    auth: true,
    body: {
      'issue_type': issueType,
      'comments': comments,
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('body: $data');
    return data; // Return the entire response data
  } else {
    print('HTTP error: ${response.statusCode}');
    throw Exception('Please try again.'); // Throw an exception on error
  }
}
