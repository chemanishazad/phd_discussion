import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

final updateProfileProvider =
    FutureProvider.family<Response, Map<String, String>>((ref, params) async {
  return await updateAnswer(
    params['id']!,
    params['answer']!,
  );
});

class MyAnswerScreen extends ConsumerStatefulWidget {
  const MyAnswerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAnswerScreenState();
}

class _MyAnswerScreenState extends ConsumerState<MyAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Answers'),
      body: profileAsyncValue.when(
        data: (profile) {
          if (profile['status'] == true) {
            final userData = profile['my_answers'];

            return ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                final answer = userData[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${answer['added_by_user']['question']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            answer['status'] == '0'
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context).primaryColor),
                                    tooltip: 'Edit Answer',
                                  )
                                : const SizedBox()
                          ],
                        ),
                        const SizedBox(height: 10),
                        HtmlWidget(
                          answer['answer'] ?? 'No answer provided',
                          textStyle: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'By ${answer['added_by_user']['name']}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              color: answer['status'] == '0'
                                  ? Colors.amber
                                  : Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  answer['status'] == '0'
                                      ? 'Pending'
                                      : 'Approved',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Added on',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                Text(
                                  '${answer['added_by_user']['date']}',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Answered on',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                Text(
                                  '${answer['date']}',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
                child:
                    Text('No answers found.', style: TextStyle(fontSize: 18)));
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
