import 'package:flutter/material.dart';

class MaungBetting extends StatefulWidget {
  static String id = 'maung_betting';
  const MaungBetting({super.key});

  @override
  State<MaungBetting> createState() => _MaungBettingState();
}

class _MaungBettingState extends State<MaungBetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maung')),
    );
  }
}
