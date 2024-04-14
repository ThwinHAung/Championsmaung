import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class UserDeposit extends StatefulWidget {
  static String id = 'user_deposit_page';
  const UserDeposit({super.key});

  @override
  State<UserDeposit> createState() => _UserDepositState();
}

class _UserDepositState extends State<UserDeposit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'CHAMPION MAUNG (User Deposit)',
          style: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
