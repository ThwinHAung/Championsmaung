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

class SSSeniorMatchView extends StatefulWidget {
  static String id = "sssenior_match_view";

  // constructor for custom radio button widget

  const SSSeniorMatchView({super.key});

  @override
  State<SSSeniorMatchView> createState() => _SSSeniorMatchViewState();
}

class _SSSeniorMatchViewState extends State<SSSeniorMatchView> {
  final storage = const FlutterSecureStorage();
  String? _token;
  List<Match> matches = [];

  @override
  void initState() {
    _getToken();

    super.initState();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchMatches();
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

  Future<void> _editMatch(int matchId) async {
    final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/editMatches/$matchId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'home_match': _homeTeamEditingController.text,
          'away_match': _awayTeamEditingController.text,
          "special_odd_last_digit": _specialOddEditingController.text,
          "over_under_last_digit": _overUnderOddEditingController.text,
        }));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print(message);
    } else {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      print(message);
    }
  }

  Future<void> _deleteMatch(int matchId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/deleteMatch');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          "match_id": matchId,
        }));
  }

  Future<void> _matchStatusUpdate(int matchId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/updateStatus{$matchId}');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          "home_goals": _homeGoalEditingController.text,
          "away_goals": _awayTeamEditingController.text,
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Leagues, Matches',
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
              padding: const EdgeInsets.all(10.0),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: matches.length,
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
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: labelText(
                    match.league_name,
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
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Match'),
                              content: const Text(
                                  'Do you really want to delete this match?'),
                              actions: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: materialButton(kError, 'Cancel',
                                            () {
                                          Navigator.pop(context);
                                        })),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      flex: 1,
                                      child:
                                          materialButton(kError, 'Delete', () {
                                        int matchId = matches[index].id;
                                        _deleteMatch(matchId);
                                      }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: kError,
                      ),
                      style: IconButton.styleFrom(iconSize: 20),
                    )),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => finishedDialog(index),
                        );
                      },
                      icon: const Icon(
                        Icons.done,
                        color: kGreen,
                      ),
                      style: IconButton.styleFrom(iconSize: 20),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                                  ? '=${match.specialOddSign}${match.specialOddLastDigit}'
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
                        customRadio('Over', 2, index),
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
                        customRadio('Under', 3, index),
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
  final TextEditingController _specialOddEditingController =
      TextEditingController();
  final TextEditingController _homeTeamEditingController =
      TextEditingController();
  final TextEditingController _awayTeamEditingController =
      TextEditingController();
  final TextEditingController _overUnderOddEditingController =
      TextEditingController();
  final TextEditingController _homeGoalEditingController =
      TextEditingController();
  final TextEditingController _awayGoalEditingController =
      TextEditingController();

  Widget editDilaog(int index) {
    Match match = matches[index];

    return AlertDialog(
      title: const Text('Edit'),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: labelText('Home Team'),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: labelText('Away Team'),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _homeTeamEditingController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: match.homeMatch,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: TextFormField(
                      controller: _awayTeamEditingController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: match.awayMatch,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              labelText('Special Odd'),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _specialOddEditingController,
                style: kTextFieldActiveStyle,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: '${match.specialOddLastDigit}'),
              ),
              const SizedBox(height: 20.0),
              labelText('Over, Under Odd'),
              const SizedBox(height: 5.0),
              TextFormField(
                controller: _overUnderOddEditingController,
                style: kTextFieldActiveStyle,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: '${match.overUnderLastDigit}'),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: materialButton(kError, 'Cancel', () {
                        Navigator.pop(context);
                      })),
                  const SizedBox(width: 5.0),
                  Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'Update', () {
                      int matchId = matches[index].id;
                      _editMatch(matchId);
                    }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget finishedDialog(int index) {
    Match match = matches[index];
    return AlertDialog(
      title: const Text('Finish Match'),
      content: const Text('Enter goal results'),
      actions: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Home Team : ${match.homeMatch}',
                    style: const TextStyle(color: kBlue, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: Text(
                    'Away Team : ${match.awayMatch}',
                    style: const TextStyle(color: kBlue, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _homeGoalEditingController,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Home Goal',
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  child: TextFormField(
                    controller: _awayGoalEditingController,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Away Goal',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: materialButton(kError, 'Cancel', () {
                      Navigator.pop(context);
                    })),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'Enter', () {
                    ();
                  }),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

///changes
