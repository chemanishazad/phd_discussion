import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class MyAnswerScreen extends ConsumerStatefulWidget {
  const MyAnswerScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAnswerScreenState();
}

class _MyAnswerScreenState extends ConsumerState<MyAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
    );
  }
}
