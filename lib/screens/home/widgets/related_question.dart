import 'package:flutter/material.dart';

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
          Text(
            'Related Questions (${relatedQuestions.length})',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: relatedQuestions.length,
            itemBuilder: (context, index) {
              final question = relatedQuestions[index];
              return Card(
                color: Colors.white,
                elevation: 6,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    question['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By: ${question['user_id']}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Posted on: ${question['date']}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatChip(
                              Icons.remove_red_eye, question['views']),
                          const SizedBox(width: 8),
                          _buildStatChip(Icons.thumb_up, question['votes']),
                          const SizedBox(width: 8),
                          _buildStatChip(Icons.comment, question['answers']),
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
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
