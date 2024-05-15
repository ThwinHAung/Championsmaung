import 'package:champion_maung/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

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
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: labelText(
                    leagues[index],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => editDilaog(index),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: kBlue,
                      ),
                      style: IconButton.styleFrom(iconSize: 20),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    const Text(
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
                            child: const Text(
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
                            child: const Text(
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimary,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              item,
              style: const TextStyle(
                color: kBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Varibales
  final TextEditingController _homeTeamEditController = TextEditingController();
  final TextEditingController _awayTeamEditController = TextEditingController();
  final TextEditingController _specialOddsEditController =
      TextEditingController();
  final TextEditingController _overUnderEditController =
      TextEditingController();

  List<Map<String, String>> poukKyayList = [
    {'name': 'Team 1', 'value': '1'},
    {'name': 'Team 2', 'value': '2'},
  ];

  String? team_value;

  late DateTime _dateTime;
  @override
  void initState() {
    super.initState();
  }

  Widget editDilaog(int index) {
    return AlertDialog(
      title: const Text('Edit'),
      actions: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: const Row(
                children: [
                  Icon(
                    Icons.list,
                    size: 16,
                    color: kPrimary,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Select',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: poukKyayList.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value']!,
                  child: Text(
                    item['name']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              value: team_value,
              onChanged: (String? value) {
                setState(() {
                  team_value = value!;
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 160,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: kBlue,
                  ),
                  color: kBlue,
                ),
                elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: kPrimary,
                iconDisabledColor: kGrey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: kBlue,
                ),
                offset: const Offset(-20, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: WidgetStateProperty.all<double>(6),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: _homeTeamEditController,
          style: kTextFieldActiveStyle,
          decoration: kTextFieldDecoration.copyWith(
            hintText: lists[index][0],
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: _awayTeamEditController,
          style: kTextFieldActiveStyle,
          decoration: kTextFieldDecoration.copyWith(
            hintText: lists[index][1],
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: _specialOddsEditController,
          style: kTextFieldActiveStyle,
          decoration: kTextFieldDecoration.copyWith(
            hintText: lists[index][2],
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: _overUnderEditController,
          style: kTextFieldActiveStyle,
          decoration: kTextFieldDecoration.copyWith(
            hintText: lists[index][3],
          ),
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            Expanded(
              flex: 4,
              child:
                  materialButton(kBlue, 'Select date&time', _myDateTimeMethod),
            ),
            Expanded(
              flex: 1,
              child: labelText(':'),
            ),
            Expanded(
              flex: 4,
              child: labelText('$DateTime'),
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                  flex: 1,
                  child: materialButton(kError, 'Cancel', () {
                    Navigator.pop(context);
                  })),
              const SizedBox(width: 5.0),
              Expanded(
                flex: 1,
                child: materialButton(kBlue, 'Update', () {
                  ();
                }),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _myDateTimeMethod() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      isForce2Digits: true,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    _dateTime = dateTime as DateTime;
  }
}
