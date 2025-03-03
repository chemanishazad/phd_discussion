import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';

class SkillsWrap extends StatefulWidget {
  final String skills;

  const SkillsWrap({super.key, required this.skills});

  @override
  State<SkillsWrap> createState() => _SkillsWrapState();
}

class _SkillsWrapState extends State<SkillsWrap> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final skillsList = widget.skills.split(',').map((s) => s.trim()).toList();
    final visibleSkills = showAll ? skillsList : skillsList.take(3).toList();

    return Wrap(
      spacing: 4.0,
      runSpacing: -8.0,
      alignment: WrapAlignment.start,
      children: [
        ...visibleSkills.map<Widget>(
          (skill) => Chip(
            label: Text(
              skill,
              style: theme.bodyMedium,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Palette.themeColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        if (skillsList.length > 3)
          GestureDetector(
            onTap: () {
              setState(() {
                showAll = !showAll;
              });
            },
            child: Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    showAll ? '▲ ' : '▼ ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    showAll ? 'Show Less' : 'Show All',
                    style: theme.bodyMedium?.copyWith(
                      color: Palette.themeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              backgroundColor: Palette.whiteColor,
              labelPadding: const EdgeInsets.symmetric(horizontal: 6.0),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Palette.themeColor),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
      ],
    );
  }
}
