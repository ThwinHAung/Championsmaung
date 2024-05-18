import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class BettingHistory extends StatefulWidget {
  static String id = 'betting_history';
  const BettingHistory({super.key});

  @override
  State<BettingHistory> createState() => _BettingHistoryState();
}

class _BettingHistoryState extends State<BettingHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Betting History',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
