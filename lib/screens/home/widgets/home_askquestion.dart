import 'package:flutter/material.dart';
import 'package:phd_discussion/core/components/custom_button.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/core/const/styles.dart';

class HomeAskQuestion extends StatelessWidget {
  const HomeAskQuestion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(context: context),
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Got a Question?',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 8),
            Text(
                'Ask your question here, and let the community provide answers, insights, or reactions.',
                style: Theme.of(context).textTheme.headlineMedium),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, '/askQuestion');
                },
                child: Text(
                  'Ask Your Question',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(
                'Once you post your question, it will be visible to everyone in the community. They can react with likes, comments, or answers!',
                style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: 8),
            Text(
                'Your question could be the one that sparks interesting discussions!',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
