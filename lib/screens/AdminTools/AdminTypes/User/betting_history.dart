import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history/body_bet_history_matches.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history/maung_bet_history_matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//here!!
class SingleBet {
  final int id;
  final String selectedOutcome;
  final double amount;
  final String status;
  final double wining_amount;
  final String slipDate; // Add matchTime field

  SingleBet({
    required this.id,
    required this.selectedOutcome,
    required this.amount,
    required this.status,
    required this.wining_amount,
    required this.slipDate, // Initialize matchTime
  });

  factory SingleBet.fromJson(Map<String, dynamic> json) {
    return SingleBet(
      id: json['id'],
      selectedOutcome: json['selected_outcome'],
      amount: double.parse(json['amount']),
      status: json['status'],
      wining_amount: double.parse(json['wining_amount']),
      slipDate: json['created_at'], // Parse matchTime from JSON
    );
  }
}

class AccumulatorBet {
  final int id;
  final double amount;
  final String status;
  final double wining_amount;
  final String slipDate;
  final int matchCount;

  AccumulatorBet({
    required this.id,
    required this.amount,
    required this.status,
    required this.wining_amount,
    required this.slipDate,
    required this.matchCount,
  });
  factory AccumulatorBet.fromJson(Map<String, dynamic> json) {
    return AccumulatorBet(
      id: json['id'],
      amount: double.parse(json['amount']),
      status: json['status'],
      wining_amount: double.parse(json['wining_amount']),
      slipDate: json['created_at'],
      matchCount: json['match_count'],
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
  String? _username;
  Map<String, List<SingleBet>> singleSlip = {};
  Map<String, List<AccumulatorBet>> accumulatorSlip = {};

  int _widgetSelectedIndex = 0;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Widget> get _widgetOptions => <Widget>[
        bodyBettingHistoryWidget(),
        maungBettingHistoryWidget(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _widgetSelectedIndex = index;
      refreshPage();
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    _username = await storage.read(key: 'user_name');
    if (_token != null && _username != null) {
      _fetchMatchesHistory(_username!);
    }
  }

  Future<void> _fetchMatchesHistory(String username) async {
    var url = Uri.parse('https://championmaung/api/getBetSlip/$username');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        if (data.containsKey('singleBets')) {
          singleSlip = {
            'singleBets': (data['singleBets'] as List)
                .map((betJson) => SingleBet.fromJson(betJson))
                .toList(),
          };
        }
        if (data.containsKey('accumulatorBets')) {
          accumulatorSlip = {
            'accumulatorBets': (data['accumulatorBets'] as List)
                .map((betJson) => AccumulatorBet.fromJson(betJson))
                .toList(),
          };
        }
      });
    } else {
      print('Error fetching data: ${response.statusCode}');
    }
  }

  Future<void> getData() async {
    await _fetchMatchesHistory(_username!);
    _refreshController.refreshCompleted();
  }

  Future<void> refreshPage() async {
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
          backgroundColor: kPrimary,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Text(
                '',
                style: TextStyle(fontSize: 0),
              ),
              label: 'BODY',
            ),
            BottomNavigationBarItem(
              icon: Text(
                '',
                style: TextStyle(fontSize: 0),
              ),
              label: 'MAUNG',
            ),
          ],
          currentIndex: _widgetSelectedIndex,
          selectedItemColor: kBlue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget bodyBettingHistoryWidget() {
    return Container(
      color: kPrimary,
      child: Column(
        children: [
          Expanded(child: bodyView()),
        ],
      ),
    );
  }

  Widget maungBettingHistoryWidget() {
    return Container(
      color: kPrimary,
      child: Column(
        children: [
          Expanded(child: maungView()),
        ],
      ),
    );
  }

  Widget bodyView() {
    List<SingleBet> singleBets = singleSlip['singleBets'] ?? [];
    if (singleBets.isEmpty) {
      return const Center(
        child: Text(
          'No Single Bets found',
          style: TextStyle(color: konPrimary),
        ),
      );
    }
    return Container(
      color: kPrimary,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: singleBets.length,
          itemBuilder: (BuildContext context, int index) {
            SingleBet singleBet = singleBets[index];

            DateTime matchTime =
                DateFormat("yyyy-MM-dd HH:mm:ss").parse(singleBet.slipDate);
            String formattedMatchTime =
                DateFormat("dd MMM yyyy hh:mm a").format(matchTime);
            // Get current time
            DateTime now = DateTime.now();

            return AnimationConfiguration.staggeredList(
              position: index,
              delay: const Duration(milliseconds: 100),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 2500),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        BodyBetHistoryMatches.id,
                        arguments:
                            singleBet.id, // Pass the accumulatorBet.id here
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: const BoxDecoration(
                        color: kOnPrimaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelText('Voucher ID'),
                                      const SizedBox(height: 5.0),
                                      labelText('Amount'),
                                      const SizedBox(height: 5.0),
                                      labelText('Wining Amount'),
                                      const SizedBox(height: 5.0),
                                      labelText('Status'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelText(': ' '${singleBet.id}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '${singleBet.amount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': '
                                          '${singleBet.wining_amount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '${singleBet.status}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kBlue, // Highlight if selected
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      'Match Time : $formattedMatchTime', // Display match time
                                      style: const TextStyle(
                                        color:
                                            kPrimary, // Change text color if selected
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget maungView() {
    List<AccumulatorBet> accumulatorBets =
        accumulatorSlip['accumulatorBets'] ?? [];
    if (accumulatorBets.isEmpty) {
      return const Center(
        child: Text(
          'No Accumulator Bets found',
          style: TextStyle(color: konPrimary),
        ),
      );
    }
    return Container(
      color: kPrimary,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: accumulatorBets.length,
          itemBuilder: (BuildContext context, int index) {
            AccumulatorBet accumulatorBet = accumulatorBets[index];

            DateTime matchTime = DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(accumulatorBet.slipDate);
            String formattedMatchTime =
                DateFormat("dd MMM yyyy hh:mm a").format(matchTime);
            // Get current time
            DateTime now = DateTime.now();

            return AnimationConfiguration.staggeredList(
              position: index,
              delay: const Duration(milliseconds: 100),
              child: SlideAnimation(
                duration: const Duration(milliseconds: 2500),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 2500),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MaungBetHistoryMatches.id,
                        arguments: accumulatorBet
                            .id, // Pass the accumulatorBet.id here
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: const BoxDecoration(
                        color: kOnPrimaryContainer,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelText('Voucher ID'),
                                      const SizedBox(height: 5.0),
                                      labelText('Number of Matches'),
                                      const SizedBox(height: 5.0),
                                      labelText('Amount'),
                                      const SizedBox(height: 5.0),
                                      labelText('Wining Amount'),
                                      const SizedBox(height: 5.0),
                                      labelText('Status'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelText(': ' '${accumulatorBet.id}'),
                                      const SizedBox(height: 5.0),
                                      labelText(
                                          ': ' '${accumulatorBet.matchCount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(
                                          ': ' '${accumulatorBet.amount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': '
                                          '${accumulatorBet.wining_amount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(
                                          ': ' '${accumulatorBet.status}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kPrimary, // Highlight if selected
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      'Match Time :$formattedMatchTime', // Display match time
                                      style: const TextStyle(
                                        color:
                                            kBlue, // Change text color if selected
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
