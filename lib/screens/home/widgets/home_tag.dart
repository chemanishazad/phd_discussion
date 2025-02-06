import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/styles.dart';

class TagCard extends StatelessWidget {
  final IconData icon;
  final String tagName;
  final int tagCount;

  const TagCard({
    Key? key,
    required this.icon,
    required this.tagName,
    required this.tagCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: cardDecoration(context: context),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.15),
            ),
            child: Icon(icon, size: 22, color: Colors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(tagName,
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Text('$tagCount', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
