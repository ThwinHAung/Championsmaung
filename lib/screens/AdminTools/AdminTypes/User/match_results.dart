import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class MatchResults extends StatefulWidget {
  static String id = 'match_results';
  const MatchResults({super.key});

  @override
  State<MatchResults> createState() => _MatchResultsState();
}

class _MatchResultsState extends State<MatchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Match Results',
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
