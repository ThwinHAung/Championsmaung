import 'package:flutter/material.dart';

class BodyBetting extends StatefulWidget {
  static String id = 'body_betting';
  const BodyBetting({super.key});

  @override
  State<BodyBetting> createState() => _BodyBettingState();
}

class _BodyBettingState extends State<BodyBetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body')),
    );
  }
}
