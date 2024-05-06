import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class SSSeniorInputsPage extends StatefulWidget {
  static String id = 'sssenior_input_page';
  const SSSeniorInputsPage({super.key});

  @override
  State<SSSeniorInputsPage> createState() => _SSSeniorInputsPageState();
}

class _SSSeniorInputsPageState extends State<SSSeniorInputsPage> {
  final storage = FlutterSecureStorage();
  String? _token;
  final TextEditingController _homeTeamController = TextEditingController();
  final TextEditingController _awayTeamController = TextEditingController();
  final TextEditingController _specialOddsController = TextEditingController();
  final TextEditingController _overUnderController = TextEditingController();
  String? selectedValue;
  String? team_value;
  List<Map<String, dynamic>> _leagueList = [];
  List<Map<String, String>> poukKyayList = [
    {'name': 'Team 1', 'value': '1'},
    {'name': 'Team 2', 'value': '2'},
  ];

  late DateTime _dateTime;
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchLeagues();
    } else {}
  }

  Future<void> _fetchLeagues() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/leagues');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> leagues = responseData['leagues'];
      setState(() {
        _leagueList = leagues
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      });
    } else {
      // Handle error
    }
  }

  Future<void> _insertMatch() async {
    final response =
        await http.post(Uri.parse('http://127.0.0.1:8000/api/addingmatch'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: json.encode({
              'league_id': selectedValue,
              'home_match': _homeTeamController.text,
              'away_match': _awayTeamController.text,
              'match_time': _dateTime.toIso8601String(),
              'special_odd_team': team_value,
              'special_odd': _specialOddsController.text,
              'over_under': _overUnderController.text
            }));
    if (response.statusCode == 200) {
      print('ok');
    } else {
      print(response.body);
    }
  }

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
                              items: _leagueList
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                      value: item['id'].toString(),
                                      child: Text(
                                        item['name'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: kPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
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
                          controller: _homeTeamController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter home team',
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        labelText('Away Team'),
                        TextFormField(
                          controller: _awayTeamController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter away team',
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        labelText('Enter Special Odds'),
                        TextFormField(
                          controller: _specialOddsController,
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
                          controller: _overUnderController,
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
                              child: materialButton(
                                  kBlue, 'Select date&time', _myDateTimeMethod),
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
                                child: materialButton(kBlue, 'Enter', () {
                                  _insertMatch();
                                }),
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
    _dateTime = dateTime as DateTime;
  }
}
