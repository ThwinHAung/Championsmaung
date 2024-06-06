import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history/body_bet_history_matches.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history/maung_bet_history_matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SingleBet {
  final int id;
  final int matchId;
  final String selectedOutcome;
  final double amount;
  final String status;
  final double wining_amount;

  SingleBet({
    required this.id,
    required this.matchId,
    required this.selectedOutcome,
    required this.amount,
    required this.status,
    required this.wining_amount,
  });
  factory SingleBet.fromJson(Map<String, dynamic> json) {
    return SingleBet(
      id: json['id'],
      matchId: json['match_id'],
      selectedOutcome: json['selected_outcome'],
      amount: double.parse(json['amount']),
      status: json['status'],
      wining_amount: double.parse(json['wining_amount']),
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
    var url = Uri.parse('http://127.0.0.1:8000/api/getBetSlip/$username');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('singleBets')) {
        setState(() {
          singleSlip = {
            'singleBets': (data['singleBets'] as List)
                .map((betJson) => SingleBet.fromJson(betJson))
                .toList(),
          };
        });
      }
    } else {
      // Handle the error appropriately
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
    // List<String> sortedLeagueNames = matchesByLeague.keys.toList();
    // sortedLeagueNames
    //     .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    List<SingleBet> singleBets = singleSlip['singleBets'] ?? [];
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
            SingleBet bet = singleBets[index];

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
                      Navigator.pushNamed(context, BodyBetHistoryMatches.id);
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
                                      labelText('Wining_amount'),
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
                                      labelText(': ' '${bet.id}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '${bet.amount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '${bet.wining_amount}'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '${bet.status}'),
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
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'show match time Here',
                                      style: TextStyle(
                                        color:
                                            kOnPrimaryContainer, // Change text color if selected
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
    return Container(
      color: kPrimary,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
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
                      Navigator.pushNamed(context, MaungBetHistoryMatches.id);
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
                                      labelText('ပွဲစဉ်အရေအတွက်'),
                                      const SizedBox(height: 5.0),
                                      labelText('လောင်းငွေ'),
                                      const SizedBox(height: 5.0),
                                      labelText('ပြန်ရငွေ'),
                                      const SizedBox(height: 5.0),
                                      labelText('နိုင် / ရှုံး'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelText(': ' '0000'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '0000'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' '0000'),
                                      const SizedBox(height: 5.0),
                                      labelText(': ' 'ACTIVE'),
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
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'show match time Here',
                                      style: TextStyle(color: kBlue),
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
