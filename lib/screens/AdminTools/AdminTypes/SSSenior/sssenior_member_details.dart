import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class SSSeniorMemberDetails extends StatefulWidget {
  static String id = 'sssenior_member_detais';
  const SSSeniorMemberDetails({super.key});

  @override
  State<SSSeniorMemberDetails> createState() => _SSSeniorMemberDetailsState();
}

class _SSSeniorMemberDetailsState extends State<SSSeniorMemberDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Members Details',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        color: kPrimary,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: view(),
          ),
        ),
      ),
    );
  }
}

Widget view() {
  return Container();
}
