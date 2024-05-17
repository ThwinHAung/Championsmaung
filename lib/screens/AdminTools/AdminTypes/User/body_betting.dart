import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class Match {
  final int id;
  final String league_name;
  final String homeMatch;
  final String awayMatch;
  final String matchTime;
  final String specialOddTeam;
  final String specialOddFirstDigit;
  final String specialOddSign;
  final int specialOddLastDigit;
  final String overUnderFirstDigit;
  final String overUnderSign;
  final int overUnderLastDigit;
  Match({
    required this.id,
    required this.league_name,
    required this.homeMatch,
    required this.awayMatch,
    required this.matchTime,
    required this.specialOddTeam,
    required this.specialOddFirstDigit,
    required this.specialOddSign,
    required this.specialOddLastDigit,
    required this.overUnderFirstDigit,
    required this.overUnderSign,
    required this.overUnderLastDigit,
  });
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      league_name: json['league_name'],
      homeMatch: json['home_match'],
      awayMatch: json['away_match'],
      matchTime: json['match_time'],
      specialOddTeam: json['special_odd_team'],
      specialOddFirstDigit: json['special_odd_first_digit'],
      specialOddSign: json['special_odd_sign'],
      specialOddLastDigit: json['special_odd_last_digit'],
      overUnderFirstDigit: json['over_under_first_digit'],
      overUnderSign: json['over_under_sign'],
      overUnderLastDigit: json['over_under_last_digit'],
    );
  }
}

class BodyBetting extends StatefulWidget {
  static String id = 'body_betting';
  const BodyBetting({super.key});

  @override
  State<BodyBetting> createState() => _BodyBettingState();
}

class _BodyBettingState extends State<BodyBetting> {
  final storage = FlutterSecureStorage();
  String? _token;
  double? _balance;
  Map<int, String> selectedValues = {};
  List<Match> matches = [];

  final TextEditingController _bodyBettingEditingController =
      TextEditingController();

  @override
  void initState() {
    _getToken();

    super.initState();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchMatches();
      _getBalance();
    }
  }

  Future<void> _getBalance() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/get_balance');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _balance = double.parse(data['balance'].toString());
      });
    }
  }

  Future<void> _fetchMatches() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/retrieve_match');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      setState(() {
        matches = jsonResponse.map((match) => Match.fromJson(match)).toList();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Body Betting',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: _buildBody(w),
      bottomNavigationBar: BottomAppBar(
        color: kOnPrimaryContainer,
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('Body ' '(0)'),
              ),
              Expanded(
                flex: 7,
                child: TextFormField(
                  controller: _bodyBettingEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount to bet',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                flex: 2,
                child: materialButton(kBlue, 'Bet', () {
                  String text = _bodyBettingEditingController.text;
                  double amount = double.tryParse(text) ??
                      0.0; // Convert text to double or default to 0.0 if parsing fails

                  // Check if user has enough balance
                  if (_balance == null || _balance! < amount) {
                    // Show dialog for insufficient balance
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Insufficient Balance'),
                        content: const Text(
                            'You do not have enough balance to place this bet.'),
                        actions: <Widget>[
                          materialButton(kError, 'OK', () {
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                    );
                  } else {
                    // Check if user has entered an amount to bet
                    if (text.isEmpty) {
                      // Show dialog for empty bet amount
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Empty Bet Amount'),
                          content: const Text('Please enter an amount to bet.'),
                          actions: <Widget>[
                            materialButton(kError, 'OK', () {
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                      );
                    } else {
                      // Both conditions are met, show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Bet'),
                          content: Text(
                              'Do you want to bet $text amount for body(0) matches?'),
                          actions: <Widget>[
                            Row(
                              children: [
                                materialButton(kError, 'Cancel', () {
                                  Navigator.pop(context);
                                }),
                                const SizedBox(width: 5.0),
                                materialButton(kBlue, 'Bet', () {
                                  // Place the bet here
                                  // You can call a function to handle the bet placement
                                  // For example: _placeBet(amount);
                                  Navigator.pop(context);
                                })
                              ],
                            )
                          ],
                        ),
                      );
                    }
                  }

                  _bodyBettingEditingController.clear();
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(double w) {
    return Container(
      color: kPrimary,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.all(w / 50),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: matches.length, // Use matches.length
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
                    child: radioContainer(index), // Use index to access matches
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget radioContainer(int index) {
    Match match = matches[index];
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
            Text(
              match.league_name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Match Time: ${match.matchTime}',
                    style: const TextStyle(color: kGrey),
                  ),
                  Row(
                    children: [
                      customRadio(match.homeMatch, 0, index),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            match.specialOddTeam == 'H' ? '<' : '',
                            style: const TextStyle(
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
                          child: Text(
                            match.specialOddFirstDigit == '0'
                                ? '=' +
                                    match.specialOddSign +
                                    match.specialOddLastDigit.toString()
                                : match.specialOddFirstDigit +
                                    match.specialOddSign +
                                    match.specialOddLastDigit.toString(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            match.specialOddTeam == 'H' ? '' : '>',
                            style: const TextStyle(
                              color: kBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      customRadio(match.awayMatch, 1, index),
                    ],
                  ),
                  Row(
                    children: [
                      customRadio("Over", 2, index),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            match.overUnderFirstDigit +
                                match.overUnderSign +
                                match.overUnderLastDigit.toString(),
                          ),
                        ),
                      ),
                      customRadio("Under", 3, index),
                    ],
                  ),
                ],
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

  // Widget materialButton(Color color, String text, VoidCallback onPressed) {
  //   return ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       kprimary: color,
  //     ),
  //     onPressed: onPressed,
  //     child: Text(text),
  //   );
  // }
  //
  // Widget labelText(String text) {
  //   return Text(
  //     text,
  //     style: const TextStyle(
  //       color: kBlack,
  //       fontSize: 16.0,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }
}
