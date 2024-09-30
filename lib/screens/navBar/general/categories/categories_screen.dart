import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Categories'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildExpansionTile(
                title: 'Starting up PhD',
                children: [
                  _buildListTile(context, 'Base Papers', Icons.book),
                  _buildListTile(context, 'PhD Admission Interview',
                      Icons.question_answer),
                  _buildListTile(context, 'PhD Concept Paper', Icons.article),
                  _buildListTile(context, 'PhD Funding', Icons.attach_money),
                  _buildListTile(
                      context, 'PhD Interview Questions', Icons.note),
                  _buildListTile(
                      context, 'PhD Research Proposal', Icons.file_copy),
                  _buildListTile(
                      context, 'PhD Statement of Purpose', Icons.text_snippet),
                  _buildListTile(context, 'PhD Synopsis', Icons.notes),
                  _buildListTile(context, 'PhD Topic Ideas', Icons.lightbulb),
                  _buildListTile(
                      context, 'PhD Topic Selection', Icons.check_circle),
                  _buildListTile(
                      context, 'Problem Statement', Icons.report_problem),
                  _buildListTile(context, 'Research Objectives', Icons.flag),
                  _buildListTile(context, 'Research Proposal Format',
                      Icons.format_list_bulleted),
                  _buildListTile(
                      context, 'Research Topic Ideas', Icons.assignment),
                  _buildListTile(
                      context, 'Synopsis Format', Icons.format_align_left),
                  _buildListTile(context, 'Topic Novelty', Icons.new_releases),
                ],
              ),
              _buildExpansionTile(
                title: 'Thesis/Dissertation Chapters',
                children: [
                  _buildListTile(context, 'Conclusion', Icons.check),
                  _buildListTile(context, 'Discussion', Icons.comment),
                  _buildListTile(context, 'Introduction', Icons.flag),
                  _buildListTile(context, 'Limitations', Icons.warning),
                  _buildListTile(
                      context, 'Literature Review', Icons.library_books),
                  _buildListTile(
                      context, 'Research Methodology', Icons.science),
                  _buildListTile(context, 'Results', Icons.assessment),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Palette.themeColor),
        ),
        children: children,
        backgroundColor: Colors.teal.shade50,
        iconColor: Palette.themeColor,
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Palette.themeColor, size: 30),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
      onTap: () {
        print(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You tapped: $title')),
        );
      },
    );
  }
}
