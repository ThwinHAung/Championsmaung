import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MaungBetting extends StatefulWidget {
  static String id = 'maung_betting';
  const MaungBetting({super.key});

  @override
  State<MaungBetting> createState() => _MaungBettingState();
}

class _MaungBettingState extends State<MaungBetting> {
  List<String> leagues = ['Premiere League', 'Spain Laliga', 'Championship'];

  List<List<String>> lists = [
    ['TeamOne 1', 'TeamTwo 1', 'Over 1', 'Under 1'],
    ['TeamOne 2', 'TeamTwo 2', 'Over 2', 'Under 2'],
    ['TeamOne 3', 'TeamTwo 3', 'Over 3', 'Under 3'],
  ];

  List<String> specialOdd = ['3-60', '1+40', '2-15'];

  List<String> overunder = ['1+60', '2-70', '3+10'];

  Map<int, String> selectedValues = {};

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
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
              itemCount: lists.length,
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
                        child: radioContainer(index),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget radioContainer(int index) {
    return Container(
      decoration: BoxDecoration(
        color: kOnPrimaryContainer,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            labelText(
              leagues[index],
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Show times here',
                      style: TextStyle(color: kGrey),
                    ),
                    Row(
                      children: [
                        customRadio(lists[index][0], 0, index),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '<',
                              style: TextStyle(
                                color: kBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(specialOdd[index]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '>',
                              style: TextStyle(
                                color: kBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        customRadio(lists[index][1], 1, index),
                      ],
                    ),
                    Row(
                      children: [
                        customRadio(lists[index][2], 2, index),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(overunder[index]),
                          ),
                        ),
                        customRadio(lists[index][3], 3, index),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customRadio(String item, int itemIndex, int listIndex) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              // Toggle selection
              if (selectedValues[listIndex] == item) {
                selectedValues[listIndex] = ''; // Unselect
              } else {
                selectedValues[listIndex] = item; // Select
              } // Update selectedValues list
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selectedValues[listIndex] == item ? kBlue : kPrimary,
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                item,
                style: TextStyle(
                  color: selectedValues[listIndex] == item ? kWhite : kBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
