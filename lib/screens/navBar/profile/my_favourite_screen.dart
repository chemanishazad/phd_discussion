import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:fluttertoast/fluttertoast.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

final deleteQuestionProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await deleteFavourite(params['id']!);
});

class MyFavouriteScreen extends ConsumerStatefulWidget {
  const MyFavouriteScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends ConsumerState<MyFavouriteScreen> {
  Future<void> _handleRefresh() async {
    await ref.refresh(profileProvider);
    Fluttertoast.showToast(
      msg: "Favorites refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Favorite Questions'),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: profileAsyncValue.when(
          data: (profile) {
            if (profile['status'] == true) {
              final userData = profile['favourite_questions'];
              return userData.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        final data = userData[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/questionDetails',
                                arguments: {
                                  'id': data['id'],
                                  'isHide': false,
                                });
                            print("Tapped on question: ${data['id']}");
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child:
                                    Icon(Icons.bookmark, color: Colors.white),
                              ),
                              title: Text(data['title'],
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              // subtitle: data['sub_title'].isEmpty
                              //     ? SizedBox()
                              //     : Padding(
                              //         padding: const EdgeInsets.only(top: 4),
                              //         child: Text(
                              //           data['sub_title'] ??
                              //               'No description available.',
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .bodyMedium,
                              //         ),
                              //       ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  size: 20,
                                ),
                                color: Colors.red[600],
                                onPressed: () async {
                                  print(data['id']);
                                  final response = await ref.read(
                                      deleteQuestionProvider({'id': data['id']})
                                          .future);
                                  final Map<String, dynamic> jsonResponse =
                                      jsonDecode(response.body);
                                  print({'$jsonResponse.body'});
                                  if (response.statusCode == 200) {
                                    ref.refresh(profileProvider);
                                    // Navigator.pop(context);

                                    Fluttertoast.showToast(
                                        msg: jsonResponse['message']);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Error voting: ${response.reasonPhrase}');
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No favorite questions yet!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'When you add favorites, they will show up here.',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black38),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
            } else {
              return const Center(
                child: Text(
                  'No questions found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              );
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong!',
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(profileProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
