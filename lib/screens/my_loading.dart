import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget {
  static String id = 'my_loading';

  @override
  Widget build(BuildContext context) {
    return Center(
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
