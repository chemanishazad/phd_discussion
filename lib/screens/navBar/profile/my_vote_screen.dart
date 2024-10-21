import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class MyVoteScreen extends ConsumerStatefulWidget {
  const MyVoteScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyVoteScreenState();
}

class _MyVoteScreenState extends ConsumerState<MyVoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
    );
  }
}
