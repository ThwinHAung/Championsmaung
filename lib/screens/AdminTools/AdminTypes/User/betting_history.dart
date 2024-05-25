import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Match {
  final int id;
  final String league_name;
  final String homeMatch;
  final String awayMatch;
  final String matchTime;
  final String homeGoals;
  final String awayGoals;
  Match({
    required this.id,
    required this.league_name,
    required this.homeMatch,
    required this.awayMatch,
    required this.matchTime,
    required this.homeGoals,
    required this.awayGoals,
  });
  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      league_name: json['league_name'],
      homeMatch: json['home_match'],
      awayMatch: json['away_match'],
      matchTime: json['match_time'],
      homeGoals: json['home_goals'].toString(),
      awayGoals: json['away_goals'].toString(),
    );
  }
}

class BettingHistory extends StatefulWidget {
  static String id = 'betting_history';
  const BettingHistory({super.key});

  @override
  State<BettingHistory> createState() => _BettingHistoryState();
}

class _BettingHistoryState extends State<BettingHistory> {
  final storage = const FlutterSecureStorage();
  String? _token;
  List<Match> matches = [];

  int _widgetSelectedIndex = 0;

  List<Widget> get _widgetOptions => <Widget>[
        bodyBettingHistoryWidget(),
        maungBettingHistoryWidget(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      refreshPage();
      _widgetSelectedIndex = index;
    });
  }

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchMatchesHistory();
    }
  }

  Future<void> _fetchMatchesHistory() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/retrieve_matchesHistory');
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getData() async {
    setState(() {
      matches.clear();
    });

    await _fetchMatchesHistory();

    _refreshController.refreshCompleted();
  }

  Future<void> refreshPage() async {
    setState(() {
      matches.clear();
    });

    await _fetchMatchesHistory();

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Betting History',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_widgetSelectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text(
              '',
              style: TextStyle(fontSize: 1),
            ),
            label: 'BODY',
          ),
          BottomNavigationBarItem(
            icon: Text(
              '',
              style: TextStyle(fontSize: 1),
            ),
            label: 'MAUNG',
          ),
        ],
        currentIndex: _widgetSelectedIndex,
        selectedItemColor: kBlue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget bodyBettingHistoryWidget() {
    return Container(
      color: kPrimary,
      child: Container(
        child: bodyView(),
      ),
    );
  }

  Widget maungBettingHistoryWidget() {
    return Container(
      color: kPrimary,
      child: Container(
        child: maungView(),
      ),
    );
  }

  Widget bodyView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: bodyBettingResults(),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
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
                        child: radioContainer(index),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget maungView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: maungBettingResults(),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
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
                        child: radioContainer(index),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget bodyBettingResults() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kOnPrimaryContainer,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Single',
                style: TextStyle(
                  color: kBlue,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Number of events'),
                        Text('Potential winnings'),
                        Text('Status'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(':'),
                        Text(':'),
                        Text(':'),
                        Text(':'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('00'),
                        Text('00'),
                        Text('00'),
                        Text('**'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget maungBettingResults() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kOnPrimaryContainer,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accumulator',
                style: TextStyle(
                  color: kBlue,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Number of events'),
                        Text('Potential winnings'),
                        Text('Status'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(':'),
                        Text(':'),
                        Text(':'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('00'),
                        Text('00'),
                        Text('**'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioContainer(int index) {
    Match match = matches[index];
    // Parse match time
    DateTime matchTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(match.matchTime);
    String formattedMatchTime =
        DateFormat("dd MMM yyyy hh:mm a").format(matchTime);
    // Get current time
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
                  flex: 7,
                  child: labelText(
                    match.league_name,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Win or Lose'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Match Time: $formattedMatchTime',
                      style: const TextStyle(color: kGrey),
                    ),
                    Row(
                      children: [
                        customRadio(match.homeMatch, 0, index),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Row(
                              children: [
                                labelText(match.homeGoals),
                                labelText('-'),
                                labelText(match.awayGoals),
                              ],
                            ),
                          ),
                        ),
                        customRadio(match.awayMatch, 1, index),
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
}
