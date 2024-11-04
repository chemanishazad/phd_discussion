import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/core/utils/service.dart';

final topQuestionProvider =
    FutureProvider.family<Response, String>((ref, id) async {
  return await getTopQuestion(id);
});

final relatedQuestionProvider =
    FutureProvider.family<Response, String>((ref, id) async {
  return await getRelatedQuestion(id);
});
final categoryQuestionProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await getCategoryQuestion(params['id']!,
      page: int.parse(params['page']!));
});
final tagQuestionProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await getTagQuestion(params['id']!, page: int.parse(params['page']!));
});

final postAnswerProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await postAnswer(params['id']!, params['answer']!);
});

Future<Response> getTopQuestion(String id) async {
  try {
    final queryParams = {'id': id};
    Response response = await ApiMaster().fire(
      path: '/gettopquestions',
      method: HttpMethod.$get,
      queryParameters: queryParams,
      auth: false,
    );

    if (kDebugMode) {
      print('Top Question Response Status Code: ${response.statusCode}');
      print('Top Question Response Body: ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to load top question: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    throw Exception("Failed to fetch top question: ${e.toString()}");
  }
}

Future<Response> getRelatedQuestion(String id) async {
  try {
    final queryParams = {'id': id};
    Response response = await ApiMaster().fire(
      path: '/getrelatedquestions',
      method: HttpMethod.$get,
      queryParameters: queryParams,
      auth: false,
    );

    if (kDebugMode) {
      print('Related Questions Response Status Code: ${response.statusCode}');
      print('Related Questions Response Body: ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load related questions: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    throw Exception("Failed to fetch related questions: ${e.toString()}");
  }
}

Future<Response> getCategoryQuestion(String id, {int page = 1}) async {
  try {
    final queryParams = {'id': id, 'page': page.toString()};
    Response response = await ApiMaster().fire(
      path: '/getquestionsbycategory',
      method: HttpMethod.$get,
      queryParameters: queryParams,
      auth: false,
    );

    if (kDebugMode) {
      print('Related Questions Response Status Code: ${response.statusCode}');
    }

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load related questions: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    throw Exception("Failed to fetch related questions: ${e.toString()}");
  }
}

Future<Response> getTagQuestion(String id, {int page = 1}) async {
  try {
    final queryParams = {'tag': id, 'page': page.toString()};
    Response response = await ApiMaster().fire(
      path: '/getquestionsbytag',
      method: HttpMethod.$get,
      queryParameters: queryParams,
      auth: false,
    );

    if (kDebugMode) {
      print('Related Questions Response Status Code: ${response.statusCode}');
      print('Related Questions Response Status : ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load related questions: ${response.statusCode}');
    }

    return response;
  } catch (e) {
    throw Exception("Failed to fetch related questions: ${e.toString()}");
  }
}

Future<Response> postAnswer(String id, String answer) async {
  try {
    final response = await ApiMaster().fire(
      path: '/postanswer',
      method: HttpMethod.$post,
      body: {'question_id': id, 'answer': answer},
      headers: {
        'Content-Type': 'application/json',
      },
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

Future<Response> postComment(String id, String answerId, String answer) async {
  try {
    final response = await ApiMaster().fire(
      path: '/postcomment',
      method: HttpMethod.$post,
      body: {'question_id': id, 'answer_id': answerId, 'comment': answer},
      headers: {
        'Content-Type': 'application/json',
      },
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

Future<Response> postVote(String id, String vote) async {
  try {
    final response = await ApiMaster().fire(
        path: '/vote',
        method: HttpMethod.$post,
        body: {'question_id': id, 'vote': vote},
        contentType: ContentType.json);

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

Future<Response> postAddFav(String id) async {
  try {
    final response = await ApiMaster().fire(
        path: '/addfavourite',
        method: HttpMethod.$post,
        body: {
          'question_id': id,
        },
        contentType: ContentType.json);

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

Future<Response> forgotPassword(String email) async {
  try {
    final response = await ApiMaster().fire(
        path: '/forgotpassword',
        method: HttpMethod.$post,
        body: {
          'email': email,
        },
        auth: false,
        contentType: ContentType.json);

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

Future<Response> postRemoveFav(String id) async {
  try {
    final response = await ApiMaster().fire(
        path: '/removefavourite',
        method: HttpMethod.$post,
        body: {
          'question_id': id,
        },
        contentType: ContentType.json);

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
