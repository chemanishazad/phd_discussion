import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/core/const/palette.dart';

import 'merchandise_home.dart';

// Providers
final bottomNavProvider = StateProvider<int>((ref) => 0);

// Screens

class MerchandiseCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("📦 Categories Screen", style: TextStyle(fontSize: 18)));
  }
}

class MerchandiseCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("🛒 Cart Screen", style: TextStyle(fontSize: 18)));
  }
}

class MerchandiseProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("👤 History Screen", style: TextStyle(fontSize: 18)));
  }
}

// Main Bottom Navigation Widget
class MerchandiseBottomNavigation extends ConsumerWidget {
  const MerchandiseBottomNavigation({super.key});

  static final List<Widget> _pages = [
    MerchandiseHome(),
    MerchandiseCategoriesScreen(),
    MerchandiseCartScreen(),
    MerchandiseProfileScreen(),
  ];

  static final List<String> _titles = [
    "Home",
    "Categories",
    "My Cart",
    "History",
  ];

  static final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.category_rounded,
    Icons.shopping_cart_rounded,
    Icons.history,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[selectedIndex],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Palette.themeColor,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
