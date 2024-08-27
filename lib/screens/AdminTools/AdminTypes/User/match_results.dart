import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/my_loading.dart';
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
      league_name: json['League'],
      homeMatch: json['HomeTeam'],
      awayMatch: json['AwayTeam'],
      matchTime: json['MatchTime'],
      homeGoals: json['HomeGoal'].toString(),
      awayGoals: json['AwayGoal'].toString(),
    );
  }
}

class MatchResults extends StatefulWidget {
  static const String id = "match_results";

  // constructor for custom radio button widget

  const MatchResults({super.key});

  @override
  State<MatchResults> createState() => _MatchResultsState();
}

class _MatchResultsState extends State<MatchResults> {
  final storage = const FlutterSecureStorage();
  String? _token;
  List<Match> matches = [];
  final RefreshController _refreshController = RefreshController();
  Map<String, List<Match>> matchesByLeague = {};

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data or perform necessary actions
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      await _fetchMatchesHistory();
    }
  }

  Future<void> getData() async {
    setState(() {
      matches.clear();
    });

    await _fetchMatchesHistory();

    _refreshController.refreshCompleted();
  }

  Future<void> _fetchMatchesHistory() async {
    var url = Uri.parse('${Config.apiUrl}/retrieve_matchesHistory');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      List<Match> matchList =
          jsonResponse.map((match) => Match.fromJson(match)).toList();
      Map<String, List<Match>> groupedMatches = {};
      for (var match in matchList) {
        if (!groupedMatches.containsKey(match.league_name)) {
          groupedMatches[match.league_name] = [];
        }
        groupedMatches[match.league_name]!.add(match);
      }
      setState(() {
        matchesByLeague = groupedMatches;
      });
    } else {
      // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> sortedLeagueNames = matchesByLeague.keys.toList();
    sortedLeagueNames
        .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Match Results',
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
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: sortedLeagueNames.length,
              itemBuilder: (context, leagueIndex) {
                String leagueName = sortedLeagueNames[leagueIndex];
                List<Match> leagueMatches = matchesByLeague[leagueName]!;
                return AnimationConfiguration.staggeredList(
                  position: leagueIndex,
                  delay: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 2500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: leagueContainer(
                            leagueName, leagueMatches, leagueIndex),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget leagueContainer(
      String leagueName, List<Match> leagueMatches, int listIndex) {
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
            labelText(leagueName),
            ...leagueMatches.asMap().entries.map((entry) {
              int matchIndex = entry.key;
              Match match = entry.value;
              bool isLastMatch = matchIndex == leagueMatches.length - 1;
              return AnimationConfiguration.staggeredList(
                position: matchIndex,
                delay: const Duration(milliseconds: 100),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 2500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: FadeInAnimation(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(milliseconds: 2500),
                    child: radioContainer(match, listIndex, isLastMatch),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget radioContainer(Match match, int listIndex, bool isLastMatch) {
    DateTime matchTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(match.matchTime);
    String formattedMatchTime =
        DateFormat("dd MMM yyyy hh:mm a").format(matchTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Match Time: $formattedMatchTime',
                style: const TextStyle(color: kGrey, fontSize: 10),
              ),
            ),
            Row(
              children: [
                customRadio(match.homeMatch, 0, listIndex),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: goalText(match.homeGoals)),
                      Expanded(flex: 1, child: goalText('-')),
                      Expanded(flex: 1, child: goalText(match.awayGoals)),
                    ],
                  ),
                ),
                customRadio(match.awayMatch, 1, listIndex),
              ],
            ),
            if (!isLastMatch) const Divider(),
          ],
        ),
      ),
    );
  }

  Widget customRadio(String item, int itemIndex, int listIndex) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimary, // Highlight if selected
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 10,
                color: kBlue, // Change text color if selected
              ),
            ),
          ),
        ),
      ),
    );
  }
}
