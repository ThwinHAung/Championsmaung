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
  List<String> leagues = ['Premiere League', 'Spain Laliga', 'Championship'];

  List<List<String>> lists = [
    ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
    ['Option A', 'Option B', 'Option C', 'Option D'],
    ['Option X', 'Option Y', 'Option Z', 'Option W'],
  ];

  // Selected value for each list
  List<String> selectedValues = List.filled(3, '');

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
          borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(leagues[index]),
              Column(
                children: lists[index]
                    .map((item) => GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle selection
                              if (selectedValues[index] == item) {
                                selectedValues[index] =
                                    ''; // Deselect the option
                              } else {
                                selectedValues[index] =
                                    item; // Select the option
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedValues.contains(item)
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(item),
                          ),
                        ))
                    .toList(),
              ),
            ],
          )),
    );
  }

  Widget listRadio(String item) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            setState(() {});
          },
          style: TextButton.styleFrom(
            backgroundColor: kOnPrimaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            item,
            style: const TextStyle(
              color: kBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget customRadio(String item) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () {
            setState(() {});
          },
          style: TextButton.styleFrom(
            backgroundColor: kOnPrimaryContainer,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            item,
            style: const TextStyle(
              color: kBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
