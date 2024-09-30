import 'package:flutter/material.dart';
import 'package:phd_discussion/core/const/palette.dart';
import 'package:phd_discussion/screens/navBar/nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Palette.themeColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () async {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          drawer: const CustomMenu(),
          body: const Center(
            child: Text('Home Screen Content'),
          ),
        ),
      ),
    );
  }
}
