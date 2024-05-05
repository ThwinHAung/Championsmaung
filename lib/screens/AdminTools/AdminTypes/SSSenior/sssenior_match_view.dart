import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SSSeniorMatchView extends StatefulWidget {
  static String id = "sssenior_match_view";

  // constructor for custom radio button widget

  const SSSeniorMatchView({super.key});

  @override
  State<SSSeniorMatchView> createState() => _SSSeniorMatchViewState();
}

class _SSSeniorMatchViewState extends State<SSSeniorMatchView> {
  List<String> matchesList = ['1', '2'];
  List<String> listValOne = ['one', 'three'];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Leagues,Matches View',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        color: kPrimary,
        child: AnimationLimiter(
          child: ListView.builder(
              padding: EdgeInsets.all(w / 50),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: matchesList.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 2500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: kOnPrimaryContainer,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                customRadio('Windows', 1),
                                customRadio('MacOS', 2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget customRadio(String text, int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              selectedIndex = index;
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: kOnPrimaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: (selectedIndex == index) ? kBlue : kGrey,
            ),
          ),
        ),
      ),
    );
  }
}
