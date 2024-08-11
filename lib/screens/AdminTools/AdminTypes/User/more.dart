import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class More extends StatefulWidget {
  static const String id = 'more';
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'More',
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
