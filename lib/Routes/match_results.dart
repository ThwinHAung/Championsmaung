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
      appBar: AppBar(title: const Text('Match Results')),
    );
  }
}
