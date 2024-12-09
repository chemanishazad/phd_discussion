import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/styles.dart';

class RelatedQuestionsSection extends StatelessWidget {
  final List<dynamic> relatedQuestions;
  final ScrollController scrollController;

  const RelatedQuestionsSection({
    super.key,
    required this.relatedQuestions,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Related Questions (${relatedQuestions.length})',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: relatedQuestions.length,
            itemBuilder: (context, index) {
              final question = relatedQuestions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  decoration: cardDecoration(
                    context: context,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(question['title'],
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('By: ${question['user_id']}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('Posted on: ${question['date']}',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildStatChip(Icons.remove_red_eye,
                                question['views'], context),
                            const SizedBox(width: 8),
                            _buildStatChip(
                                Icons.thumb_up, question['votes'], context),
                            const SizedBox(width: 8),
                            _buildStatChip(
                                Icons.comment, question['answers'], context),
                          ],
                        ),
                      ],
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                      print(question['id']);
                      Navigator.pushNamed(context, '/questionDetails',
                          arguments: {
                            'id': question['id'],
                            'isHide': true,
                          });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String count, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16),
        SizedBox(width: 4),
        Text(count, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
