import 'package:flutter/material.dart';

class RelatedQuestionsSection extends StatelessWidget {
  final List<dynamic> relatedQuestions;

  const RelatedQuestionsSection({super.key, required this.relatedQuestions});

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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: relatedQuestions.length,
            itemBuilder: (context, index) {
              final question = relatedQuestions[index];
              return Card(
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By: ${question['user_id']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Posted on: ${question['date']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/questionDetails',
                        arguments: question['id']);
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
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(count, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
