import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/provider/NavProvider/profile/profileProvider.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return await getProfile();
});

class MyVoteScreen extends ConsumerStatefulWidget {
  const MyVoteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyVoteScreenState();
}

class _MyVoteScreenState extends ConsumerState<MyVoteScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Votes'),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(profileProvider);
        },
        child: profileAsyncValue.when(
          data: (profile) {
            if (profile['status'] == true) {
              final userData = profile['my_votes'];

              return ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  final question = userData[index];
                  return _buildQuestionCard(question);
                },
              );
            } else {
              return const Center(
                  child: Text('No questions found.',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)));
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/questionDetails', arguments: {
          'id': question['question_details']['id'],
          'isHide': false,
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question['question_details']['title'] ?? 'No title',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              _buildDateInfo(question),
              _buildStatsRow(question),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn(
            Icons.visibility, 'Views', question['question_details']['views']),
        _buildInfoColumn(
            Icons.thumb_up, 'Votes', question['question_details']['votes']),
        _buildInfoColumn(Icons.question_answer, 'Answers',
            question['question_details']['answers']),
      ],
    );
  }

  Widget _buildInfoColumn(IconData icon, String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 4),
            Text(title, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child:
              Text(value ?? '0', style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }

  Widget _buildDateInfo(Map<String, dynamic> question) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateColumn('Added on', question['question_details']['date']),
            _buildDateColumn(
                'Answered on', question['question_details']['modify_on']),
          ],
        ),
        const Divider(height: 20),
      ],
    );
  }

  Widget _buildDateColumn(String label, String? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(date ?? 'N/A', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
