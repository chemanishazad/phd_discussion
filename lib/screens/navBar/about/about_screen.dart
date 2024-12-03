import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'About Us'),
      body: Container(
        decoration: cardDecoration(context: context),
        child: SingleChildScrollView(
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
                _buildGridItems(context), // Pass context here
              ],
            ),
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

  Widget _buildGridItems(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCustomCard(
          '1',
          'Research Challenges',
          'Explore common challenges faced by PhD scholars and ways to overcome them.',
          Icons.help_outline,
          context, // Pass context here
        ),
        _buildCustomCard(
          '2',
          'Funding Opportunities',
          'Find various funding sources available for research projects.',
          Icons.monetization_on,
          context, // Pass context here
        ),
        _buildCustomCard(
          '3',
          'Time Management',
          'Tips and tricks to manage your time effectively during research.',
          Icons.access_time,
          context, // Pass context here
        ),
        _buildCustomCard(
          '4',
          'Networking',
          'Learn the importance of networking and how to build professional connections.',
          Icons.people,
          context, // Pass context here
        ),
      ],
    );
  }

  Widget _buildCustomCard(String number, String title, String description,
      IconData icon, BuildContext context) {
    return Container(
      decoration: boxDecoration(context: context),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildNumberBadge(number),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildNumberBadge(String number) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        number,
        style: const TextStyle(
          color: Palette.themeColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
