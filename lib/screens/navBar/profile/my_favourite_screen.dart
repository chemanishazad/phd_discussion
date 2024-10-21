import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class MyFavouriteScreen extends ConsumerStatefulWidget {
  const MyFavouriteScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends ConsumerState<MyFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
    );
  }
}
