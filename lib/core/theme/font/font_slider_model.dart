import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/theme/font/font_sizer.dart';

class FontSizeSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSizeOption = ref.watch(fontSizeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Font Size:",
            style: Theme.of(context).textTheme.bodyMedium),
        Slider(
          value: fontSizeOption,
          min: 8.0,
          max: 16.0,
          divisions: 4,
          onChanged: (newValue) {
            ref.read(fontSizeProvider.notifier).state = newValue;
          },
        ),
      ],
    );
  }
}
