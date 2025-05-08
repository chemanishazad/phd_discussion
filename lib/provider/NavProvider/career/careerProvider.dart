import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/utils/service2.dart';
import 'package:phd_discussion/models/auth/jobApplyModel.dart';

final jobCategoriesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    Response response = await ApiMaster2().fire(
      path: '/careers/getJobCategories',
      method: HttpMethod.$get,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return jsonData;
    } else {
      throw Exception('Failed to fetch jobs');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
});
final appliedJobProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    Response response = await ApiMaster2().fire(
      path: '/careers/getAppliedJobs',
      method: HttpMethod.$get,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return jsonData;
    } else {
      throw Exception('Failed to fetch jobs');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
});
final locationProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    Response response = await ApiMaster2().fire(
      path: '/common/getLocations',
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
final categoriesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  try {
    Response response = await ApiMaster2().fire(
      path: '/common/getCategories',
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
final jobCategoryListProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
  (ref, arg) async {
    final param = {
      'category_id': arg['id'],
      'job_id': arg['jobId'],
    };
    try {
      final response = await ApiMaster2().fire(
        path: '/careers/getJobsByCategory',
        queryParameters: param,
        method: HttpMethod.$get,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('response$jsonData');
        return jsonData;
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching jobs: $e');
    }
  },
);
final latestJobListProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
  (ref, arg) async {
    final param = {
      'category': arg['category'],
      'location': arg['location'],
      'experience': arg['experience'],
      'fromSalary': arg['fromSalary'],
      'toSalary': arg['toSalary']
    };
    try {
      final response = await ApiMaster2().fire(
        path: '/careers/getLatestJobs',
        queryParameters: param,
        method: HttpMethod.$get,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // print('response$jsonData');
        return jsonData;
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      print(e);
      throw Exception('Error fetching jobs: $e');
    }
  },
);
final jobApplyProvider =
    FutureProvider.family<Map<String, dynamic>, JobApplyModel>(
        (ref, params) async {
  try {
    final fields = {
      'job_id': params.jobId,
      'name': params.name,
      'mobile': params.mobile,
      'pref_location': params.prefLocation,
      'current_location': params.currentLocation,
      'highest_qualification': params.highestQualification,
      'work_experience': params.workExperience,
      'current_ctc': params.currentCtc,
      'reason_for_apply': params.reasonForApply,
    };
    print(fields);

    final List<String> fileFieldNames = ['attach_resume'];
    Response response = await ApiMaster2().fire(
      path: '/careers/applyForJob',
      method: HttpMethod.$formdata,
      fileFieldNames: fileFieldNames,
      multipartFields: fields,
      files: params.file,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('data${data}');
      return data;
    } else {
      return {'status': false, 'message': 'Failed to fetch skills'};
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
});

final webinarDataProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, arg) async {
  final param = {
    'webinar_id': arg['id'],
  };
  try {
    Response response = await ApiMaster2().fire(
      path: '/webinars/getWebinars',
      method: HttpMethod.$get,
      queryParameters: param,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Response >>$jsonData');

      return jsonData;
    } else {
      throw Exception('Failed to fetch jobs');
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
});

final webinarRegister =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, params) async {
  try {
    Response response = await ApiMaster2().fire(
      path: '/webinars/registerForWebinar',
      method: HttpMethod.$post,
      body: {
        'webinar_id': params['webinar_id'],
        'full_name': params['full_name'],
        'email': params['email'],
        'phone': params['phone'],
        'area_of_research': params['area_of_research'],
        'current_stage': params['current_stage'],
        'university_name': params['university_name'],
        'full_address': params['full_address'],
        'city': params['city'],
        'state': params['state'],
        'pincode': params['pincode'],
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      return data;
    }
  } catch (e) {
    throw Exception('Error: ${e.toString()}');
  }
});
