import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/screens/navBar/related/phdAdmission/grid_card.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PhdAdmission extends StatelessWidget {
  const PhdAdmission({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'PhD Admission'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSectionTitle('PhD Discussions', Icons.school),
              _buildSectionContent(
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Dignissimos a itaque eveniet culpa minima esse aliquam minus? Earum, natus! Doloremque obcaecati nemo, ex ipsum voluptas illum facilis repellat natus sint.Lorem ipsum dolor sit amet consectetur adipisicing elit. Dignissimos a itaque eveniet culpa minima esse aliquam minus? Earum, natus! Doloremque obcaecati nemo, ex ipsum voluptas illum facilis repellat natus sint. \n \nLorem ipsum dolor sit amet consectetur adipisicing elit. Dignissimos a itaque eveniet culpa minima esse aliquam minus? Earum, natus! Doloremque obcaecati nemo, ex ipsum voluptas illum facilis repellat natus sint'),
              Image.asset(
                'assets/images/aboutphd.png',
                height: 25.h,
              ),
              SizedBox(
                height: 2.h,
              ),
              _buildSectionContent2(
                  'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Odio possimus dolorum mol?'),
              _buildSectionContent(
                  'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Modi et nostrum quam natus, tenetur sed cupiditate.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Modi et nostrum quam natus, tenetur sed cupiditate.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Modi et nostrum quam natus, tenetur sed cupiditate.Lorem ipsum dolor sit amet, consectetur adipisicing elit.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Modi et nostrum quam natus, tenetur sed cupiditate.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Modi et nostrum quam natus, tenetur sed cupiditate.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Modi et nostrum quam natus, tenetur sed cupiditate.Lorem ipsum dolor sit amet, consectetur adipisicing elit.'),
              SizedBox(
                height: 2.h,
              ),
              _buildGridItems(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildGridItems() {
  List<GridItem> items = [
    GridItem(
      number: '1',
      title: 'Research Challenges',
      description:
          'Explore common challenges faced by PhD scholars and ways to overcome them.',
      icon: Icons.help_outline,
    ),
    GridItem(
      number: '2',
      title: 'Funding Opportunities',
      description:
          'Find various funding sources available for research projects.',
      icon: Icons.monetization_on,
    ),
    GridItem(
      number: '3',
      title: 'Time Management',
      description:
          'Tips and tricks to manage your time effectively during research.',
      icon: Icons.access_time,
    ),
    GridItem(
      number: '4',
      title: 'Networking',
      description:
          'Learn the importance of networking and how to build professional connections.',
      icon: Icons.people,
    ),
  ];

  return GridView.count(
    shrinkWrap: true,
    crossAxisCount: 1,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 2.5,
    physics: const NeverScrollableScrollPhysics(),
    children: items.map((item) => item.buildCard()).toList(),
  );
}

Widget _buildSectionTitle(String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: Palette.themeColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Palette.themeColor,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionContent(String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      content,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
    ),
  );
}

Widget _buildSectionContent2(String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      content,
      textAlign: TextAlign.justify,
      style: const TextStyle(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
    ),
  );
}
