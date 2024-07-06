import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class SSSeniorInputsPage extends StatefulWidget {
  static String id = 'sssenior_input_page';
  const SSSeniorInputsPage({super.key});

  @override
  State<SSSeniorInputsPage> createState() => _SSSeniorInputsPageState();
}

class _SSSeniorInputsPageState extends State<SSSeniorInputsPage> {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? league_value;
  String? team_value;
  String? specialOdd_goals;
  String? specialOdd_calculate_value;
  final TextEditingController _specialOddController = TextEditingController();
  final TextEditingController _homeTeamController = TextEditingController();
  final TextEditingController _awayTeamController = TextEditingController();
  String? overUnder_goals;
  String? overUnder_calculate_value;
  final TextEditingController _overUnderOddController = TextEditingController();
  List<Map<String, dynamic>> _leagueList = [];

  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getToken();
    // specialOdd_calculate_value = calculatingSigns.first['value'];
  }

  @override
  void dispose() {
    _specialOddController.dispose();
    _homeTeamController.dispose();
    _awayTeamController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd | h:mm a').format(_dateTime);
    return Scaffold(
      backgroundColor: kPrimary,
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
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelText('League'),
                        const SizedBox(height: 10.0),
                        DropdownButtonHideUnderline(
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
                            items: _leagueList.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'].toString(),
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
                            value: league_value,
                            onChanged: (String? value) {
                              setState(() {
                                league_value = value!;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
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
                        const SizedBox(height: 10.0),
                        labelText('Special Odd'),
                        const SizedBox(height: 10.0),
                        DropdownButtonHideUnderline(
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
                                    'Special Odd Team',
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
                            items: specialOddTeam.map((item) {
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
                              width: double.infinity,
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
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
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
                                          'Select Goals',
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
                                  items: goalsDropdown.map((item) {
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
                                  value: specialOdd_goals,
                                  onChanged: (String? value) {
                                    setState(() {
                                      specialOdd_goals = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
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
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
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
                                          '+',
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
                                  items: calculatingSigns.map((item) {
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
                                  value: specialOdd_calculate_value,
                                  onChanged: (String? value) {
                                    print(value);
                                    setState(() {
                                      specialOdd_calculate_value = value;
                                      print(specialOdd_calculate_value);
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
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
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _specialOddController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Special Odd',
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _homeTeamController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Home Team',
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _awayTeamController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Away Team',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        labelText('Over, Under Odd'),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
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
                                          'Select Goals',
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
                                  items: OverUnderGoalsDropdown.map((item) {
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
                                  value: overUnder_goals,
                                  onChanged: (String? value) {
                                    setState(() {
                                      overUnder_goals = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
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
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              flex: 1,
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
                                          '+',
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
                                  items: calculatingSigns.map((item) {
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
                                  value: overUnder_calculate_value,
                                  onChanged: (String? value) {
                                    setState(() {
                                      overUnder_calculate_value = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
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
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _overUnderOddController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Over, Under odd'),
                        ),
                        const SizedBox(height: 10.0),
                        labelText('Enter Date & Time'),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: materialButton(
                                  kBlue, 'Select date&time', _myDateTimeMethod),
                            ),
                            Expanded(
                              flex: 1,
                              child: labelText(':'),
                            ),
                            Expanded(
                              flex: 4,
                              child: labelText(formattedDate),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              const SizedBox(width: 5.0),
                              Expanded(
                                flex: 1,
                                child: materialButton(kBlue, 'Enter', () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Add Match?"),
                                        content: const Text(
                                            'Do you rally want to add this match info?'),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: materialButton(
                                                      kError, 'Cancel', () {
                                                    Navigator.pop(context);
                                                  })),
                                              const SizedBox(width: 5.0),
                                              Expanded(
                                                  flex: 1,
                                                  child: materialButton(
                                                      kBlue, 'Enter', () {
                                                    _insertMatch();
                                                  })),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  );
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

  Future<void> _insertMatch() async {
    final response =
        await http.post(Uri.parse('http://127.0.0.1:8000/api/addingmatch'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_token',
            },
            body: json.encode({
              'league_id': league_value,
              'home_match': _homeTeamController.text,
              'away_match': _awayTeamController.text,
              'match_time': _dateTime.toIso8601String(),
              'special_odd_team': team_value,
              "special_odd_first_digit": specialOdd_goals,
              "special_odd_sign": specialOdd_calculate_value,
              "special_odd_last_digit": _specialOddController.text,
              "over_under_first_digit": overUnder_goals,
              "over_under_sign": overUnder_calculate_value,
              "over_under_last_digit": _overUnderOddController.text,
            }));
    if (response.statusCode == 200) {
      Navigator.pop(context);

      _homeTeamController.clear();
      _awayTeamController.clear();
      _specialOddController.clear();
      _overUnderOddController.clear();

      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print(message);
      _successDialog(context, message);
    } else {
      Navigator.pop(context);
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print(message);
      _failedDialog(context, message);
    }
  }

  void _successDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      Navigator.pop(context);
                    })),
              ],
            )
          ],
        );
      },
    );
  }

  void _failedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Failed"),
          content: Text(message),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      Navigator.pop(context);
                    })),
              ],
            )
          ],
        );
      },
    );
  }

  void _myDateTimeMethod() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(const Duration(days: 3652)),
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

    setState(() {
      _dateTime = dateTime!;
    });
  }
}
