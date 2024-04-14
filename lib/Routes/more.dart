import 'package:flutter/material.dart';

class More extends StatefulWidget {
  static String id = 'more';
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
    );
  }
}
