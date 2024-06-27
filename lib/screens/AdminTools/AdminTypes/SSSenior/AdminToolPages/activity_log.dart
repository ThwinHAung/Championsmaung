import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class ActivityLogScreen extends StatefulWidget {
  static String id = 'activity_log';
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          backgroundColor: kPrimary,
          centerTitle: true,
          title: const Text(
            'Activity Log',
            style: TextStyle(
              color: kBlack,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Container(),
      ),
    );
  }
}
