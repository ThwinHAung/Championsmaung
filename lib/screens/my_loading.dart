import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget with WidgetsBindingObserver {
  static const String id = 'my_loading';

  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(kBlue),
        ),
      ),
    );
  }
}
