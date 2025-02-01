import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

final List<Map<String, dynamic>> _discussionTopics = [
  {
    'number': '1',
    'title': 'Research Challenges',
    'description': 'Explore common challenges faced by PhD scholars.',
    'icon': Icons.help_outline,
  },
  {
    'number': '2',
    'title': 'Funding Opportunities',
    'description': 'Find various funding sources available for research.',
    'icon': Icons.currency_rupee_outlined,
  },
  {
    'number': '3',
    'title': 'Time Management',
    'description': 'Tips and tricks to manage your time effectively.',
    'icon': Icons.access_time,
  },
  {
    'number': '4',
    'title': 'Networking',
    'description': 'Learn how to build professional connections.',
    'icon': Icons.people,
  },
];

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'About Us'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('PhD Discussions', Icons.school, context),
              _buildSectionContent(
                'PhD discussions serve as a platform to assist PhD scholars facing challenges while pursuing their research work. '
                'Inadequate supervisor support, lack of resources, extensive coursework, and fast-approaching deadlines are just the tip of the iceberg.',
                context,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Discussion Topics', Icons.topic, context),
              const SizedBox(height: 10),
              _buildListItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String content, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(content, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Widget _buildListItems(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _discussionTopics.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final topic = _discussionTopics[index];
        return _buildCustomCard(
          topic['number'],
          topic['title'],
          topic['description'],
          topic['icon'],
          context,
        );
      },
    );
  }

  Widget _buildCustomCard(String number, String title, String description,
      IconData icon, BuildContext context) {
    return Container(
      decoration: cardDecoration(context: context),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Palette.themeColor.withOpacity(0.1),
              child: Icon(icon, color: Palette.themeColor, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
