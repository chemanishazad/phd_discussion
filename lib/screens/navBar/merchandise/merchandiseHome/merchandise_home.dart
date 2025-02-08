import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MerchandiseHome extends ConsumerStatefulWidget {
  const MerchandiseHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MerchandiseHomeState();
}

class _MerchandiseHomeState extends ConsumerState<MerchandiseHome> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("🏠 Home Screen", style: TextStyle(fontSize: 18)));
  }
}
