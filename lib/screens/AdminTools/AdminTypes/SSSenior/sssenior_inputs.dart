import 'package:champion_maung/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class SSSeniorInputsPage extends StatefulWidget {
  static String id = 'sssenior_input_page';
  const SSSeniorInputsPage({super.key});

  @override
  State<SSSeniorInputsPage> createState() => _SSSeniorInputsPageState();
}

class _SSSeniorInputsPageState extends State<SSSeniorInputsPage> {
  List<String> leagueList = [
    'Premiere League',
    'Spain Laliga',
  ];
  List<String> poukKyayList = ['Team 1', 'Team 2'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Input Leagues, Matches and Bets',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: kPrimary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelText('Select League'),
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
                              items: leagueList
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
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
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        labelText('Home Team'),
                        TextFormField(
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter home team',
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        labelText('Away Team'),
                        TextFormField(
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter away team',
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        labelText('Enter Special Odds'),
                        TextFormField(
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Special Odds',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        labelText('Select Special Odds team'),
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
                              items: poukKyayList
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
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
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        labelText('Over,Under odds'),
                        TextFormField(
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter over,under odds',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        labelText('Enter Date & Time'),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: materialButton(kBlue,
                                  'Open date&time picker', _myDateTimeMethod),
                            ),
                            Expanded(
                              flex: 1,
                              child: labelText(':'),
                            ),
                            Expanded(
                              flex: 4,
                              child: labelText('show date time here'),
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
                                child: materialButton(kBlue, 'Enter', () {}),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

    print("dateTime: $dateTime");
  }
}
