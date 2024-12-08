import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_payment_history_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserTransition {
  final String date;
  final double totalIn;
  final double totalWin;
  final double totalBet;
  final double totalOut;
  final String start;
  final String end;

  UserTransition({
    required this.date,
    required this.totalIn,
    required this.totalWin,
    required this.totalBet,
    required this.totalOut,
    required this.start,
    required this.end,
  });

  factory UserTransition.fromJson(Map<String, dynamic> json) {
    return UserTransition(
      date: json['date'] as String,
      totalIn: double.parse(json['total_in'] ?? '0.0'),
      totalWin: double.parse(json['total_win'] ?? '0.0'),
      totalBet: double.parse(json['total_bet'] ?? '0.0'),
      totalOut: double.parse(json['total_out'] ?? '0.0'),
      start: json['start'] as String,
      end: json['end'] as String,
    );
  }
}

class UserPaymentHistory extends StatefulWidget {
  const UserPaymentHistory({super.key});

  static const String id = 'user_payment_history';

  @override
  State<UserPaymentHistory> createState() => _UserPaymentHistoryState();
}

class _UserPaymentHistoryState extends State<UserPaymentHistory> {
  TextEditingController _dateRangeFromController = TextEditingController();
  TextEditingController _dateRangetoController = TextEditingController();
  String _selectedSortOption = 'Date'; // Default selected option

  final storage = const FlutterSecureStorage();
  List<UserTransition> _transitions = [];
  String? _token;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      fetchPaymentHistory();
    }
  }

  Future<void> fetchPaymentHistoryWithDate(
      String startDate, String endDate) async {
    var url = Uri.parse(
        '${Config.apiUrl}/getUserTrasitionWithDate?start_date=$startDate&end_date=$endDate');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List<dynamic>;
      setState(() {
        _transitions = jsonResponse
            .map(
                (json) => UserTransition.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }
  }

  Future<void> fetchPaymentHistory() async {
    var url = Uri.parse('${Config.apiUrl}/getUserTrasition');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List<dynamic>;
      setState(() {
        _transitions = jsonResponse
            .map(
                (json) => UserTransition.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }
  }

  void _showCustomDateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date Range.'),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _dateRangeFromController,
              style: kTextFieldActiveStyle,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'From',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dateRangeFromController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _dateRangetoController,
              style: kTextFieldActiveStyle,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'To',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  _dateRangetoController.text =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                }
              },
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: materialButton(kError, 'Cancel', () {
                  Navigator.pop(context);
                }),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: materialButton(kBlue, 'Submit', () {
                  String startDate = _dateRangeFromController.text;
                  String endDate = _dateRangetoController.text;

                  if (startDate.isNotEmpty && endDate.isNotEmpty) {
                    fetchPaymentHistoryWithDate(startDate, endDate);
                    Navigator.pop(context); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select both dates")),
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(String date) {
    Navigator.pushNamed(context, UserPaymentHistoryDetails.id, arguments: date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'PAYMENT HISTORY',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.sort, color: konPrimary),
              onSelected: (String value) {
                setState(() {
                  _selectedSortOption = value;
                });
                if (value == '3') {
                  _showCustomDateDialog();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: '3',
                  child: Text(' Custom  '),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: kPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: labelText(
                      _transitions.isNotEmpty
                          ? '${_transitions.first.date} အဖွင့်လက်ကျန်' // Start date from the first entry
                          : 'No Data Available', // Fallback if the list is empty
                    ),
                  ),
                  labelText(_transitions.length.toString()),
                ],
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _transitions.length,
                  itemBuilder: (context, index) {
                    UserTransition transition = _transitions[index];
                    return GestureDetector(
                      onTap: () => _navigateToDetails(
                          transition.date), // Pass widget-specific ID
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: kOnPrimaryContainer,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: kBlack,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kBlue,
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                    child: Text(
                                      transition.date,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('သွင်းငွေ'),
                                labelText(transition.totalIn.toString()),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('ပြန်ရငွေ'),
                                labelText(transition.totalWin.toString()),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('လောင်းငွေ'),
                                labelText(transition.totalBet.toString()),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('ထုတ်ငွေ'),
                                labelText(
                                    "- ${transition.totalOut.toString()}"),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('လက်ကျန်'),
                                labelText((transition.totalIn -
                                        (transition.totalOut +
                                            transition.totalBet))
                                    .toString())
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              '${transition.start} နာရီမှ - ${transition.end} နာရီအထိ',
                              // '22-2-2024' +
                              //     'နေ့လယ် ၁၂ နာရီမှ' +
                              //     '23-2-2024' +
                              //     'နေ့လယ် ၁၂ နာရီအထိ',
                              style: TextStyle(color: kBlue, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
