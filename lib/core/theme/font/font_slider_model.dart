  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:phd_discussion/core/theme/font/font_sizer.dart';

  class FontSizeSlider extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      // Watch the current font size from the provider
      final fontSizeOption = ref.watch(fontSizeProvider);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Font Size:",
              style: Theme.of(context).textTheme.titleLarge),
          Slider(
            value: fontSizeOption,
            min: 12.0, // Minimum font size
            max: 30.0, // Maximum font size
            divisions: 18, // Number of divisions on the slider
            onChanged: (newValue) {
              // Update the font size state in the provider
              ref.read(fontSizeProvider.notifier).state = newValue;
            },
          ),
        ],
      );
    }
  }
