import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';

import 'appliedJob/applied_job.dart';
import 'categoryJob/category_job.dart';
import 'latestJob/latest_job.dart';

// Providers
final bottomNavProvider = StateProvider<int>((ref) => 0);

// Main Bottom Navigation Widget
class CareerBottomNavigation extends ConsumerWidget {
  const CareerBottomNavigation({super.key});

  static final List<Widget> _pages = [
    CategoryJob(),
    LatestJob(),
    AppliedJob(),
  ];

  static final List<String> _titles = [
    "Categories",
    "Latest Jobs",
    "Applied Jobs",
  ];

  static final List<IconData> _icons = [
    Icons.category_rounded,
    Icons.work_outline_rounded,
    Icons.history_rounded,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
          selectedItemColor: Palette.themeColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 9),
          items: List.generate(_titles.length, (index) {
            return BottomNavigationBarItem(
              icon: Icon(_icons[index]),
              label: _titles[index],
            );
          }),
        ),
      ),
    );
  }
}
