import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//here!!
class Body {
  final String selectedOutcome;
  final String amount;
  final String userStatus;
  final String winingAmount;
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
  final int? homeGoals;
  final int? awayGoals;
  final String status;

  Body({
    required this.selectedOutcome,
    required this.amount,
    required this.userStatus,
    required this.winingAmount,
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
    this.homeGoals,
    this.awayGoals,
    required this.status,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      selectedOutcome: json['selected_outcome'],
      amount: json['amount'],
      userStatus: json['user_status'],
      winingAmount: json['wining_amount'],
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
      homeGoals: json['home_goals'],
      awayGoals: json['away_goals'],
      status: json['status'],
    );
  }
}

class BodyBetHistoryMatches extends StatefulWidget {
  static String id = "body_bet_history_matches";

  // constructor for custom radio button widget

  const BodyBetHistoryMatches({super.key});

  @override
  State<BodyBetHistoryMatches> createState() => _BodyBetHistoryMatchesState();
}

class _BodyBetHistoryMatchesState extends State<BodyBetHistoryMatches> {
  final storage = const FlutterSecureStorage();
  String? _token;
  List<Body> body_matches = [];
  int? betId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        betId = args as int;
        _getToken();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null && betId != null) {
      _fetchBetDetails(betId!);
    }
  }

  Future<void> _fetchBetDetails(int betId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/getSingleBetSlip/$betId');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        body_matches.add(Body.fromJson(jsonResponse['bet']));
      });
    } else {}
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getData() async {
    setState(() {
      body_matches.clear();
    });

    await _fetchBetDetails(betId!);

    _refreshController.refreshCompleted();
  }

  Future<void> refreshPage() async {
    setState(() {
      body_matches.clear();
    });

    await _fetchBetDetails(betId!);

    _refreshController.refreshCompleted();
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Sort matches by time

    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Body Bet History',
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
          child: SmartRefresher(
            controller: _refreshController,
            header: WaterDropHeader(
              waterDropColor: kBlue,
              refresh: const MyLoading(),
              complete: Container(),
              completeDuration: Duration.zero,
            ),
            onRefresh: () => getData(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: body_matches.length,
              itemBuilder: (context, index) {
                Body match = body_matches[index];
                bool isLastMatch = index == body_matches.length - 1;
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: kOnPrimaryContainer,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // League Name Header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: labelText(match.league_name),
                              ),
                              // Matches for the League
                              radioContainer(match, isLastMatch),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Handle onTap for Home
              },
              child: Text(
                  'Amount = ${body_matches.isNotEmpty ? body_matches[0].amount : ""}'),
            ),
            GestureDetector(
              onTap: () {
                // Handle onTap for Search
              },
              child: Text(
                  'Winning Amount = ${body_matches.isNotEmpty ? body_matches[0].winingAmount : ""}'),
            ),
            GestureDetector(
              onTap: () {
                // Handle onTap for Profile
              },
              child: Text(
                  'Status = ${body_matches.isNotEmpty ? body_matches[0].status : ""}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget radioContainer(Body match, bool isLastMatch) {
    // Parse match time
    DateTime matchTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(match.matchTime);
    String formattedMatchTime =
        DateFormat("dd MMM yyyy hh:mm a").format(matchTime);

    String homeGoals = match.homeGoals?.toString() ?? "0";
    String awayGoals = match.awayGoals?.toString() ?? "0";

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(17.0, 10, 0, 10),
                    child: Text(
                      'Match Time: $formattedMatchTime',
                      style: const TextStyle(color: kGrey, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      customRadioSpecialOddLeft(match.homeMatch, 0, 1),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$homeGoals',
                            style: const TextStyle(
                              color: kBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            '-',
                            style: TextStyle(
                              color: kBlack,
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
                            '$awayGoals',
                            style: const TextStyle(
                              color: kBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      customRadioSpecialOddRight(match.awayMatch, 1, 3),
                    ],
                  ),
                  Row(
                    children: [
                      customRadioLeft('Over', 2, 2),
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
                      customRadioRight('Under', 3, 4),
                    ],
                  ),
                ],
              ),
            ), // Only render divider if not the last match
          ],
        ),
      ),
    );
  }

  Widget customRadioSpecialOddLeft(String item, int itemIndex, int listIndex) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimary,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kBlue,
                    ),
                    child: const Text(
                      textAlign: TextAlign.center,
                      '3+45',
                      style: TextStyle(
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    item,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: kBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customRadioSpecialOddRight(String item, int itemIndex, int listIndex) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimary,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: kBlue,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kBlue,
                    ),
                    child: const Text(
                      textAlign: TextAlign.center,
                      '3+45',
                      style: TextStyle(
                        color: kWhite,
                      ),
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

  Widget customRadioLeft(String item, int itemIndex, int listIndex) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimary,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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

  Widget customRadioRight(String item, int itemIndex, int listIndex) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimary,
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
}

///changes
