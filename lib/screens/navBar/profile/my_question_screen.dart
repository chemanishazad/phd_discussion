import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phd_discussion/screens/navBar/widget/appBar.dart';

class MyQuestionScreen extends ConsumerStatefulWidget {
  const MyQuestionScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyQuestuionScreenState();
}

class _MyQuestuionScreenState extends ConsumerState<MyQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
    );
  }
}
