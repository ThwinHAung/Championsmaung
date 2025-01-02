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
  final DateTime matchTime;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final int hdpGoal;
  final int hdpUnit;
  final int gpGoal;
  final int gpUnit;
  final bool homeUp;
  final bool high;

  Match({
    required this.id,
    required this.matchTime,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.hdpGoal,
    required this.hdpUnit,
    required this.gpGoal,
    required this.gpUnit,
    required this.homeUp,
    required this.high,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as int,
      matchTime: DateTime.parse(json['MatchTime'] as String),
      league: json['League'] as String,
      homeTeam: json['HomeTeam'] as String,
      awayTeam: json['AwayTeam'] as String,
      hdpGoal: json['HdpGoal'] as int,
      hdpUnit: json['HdpUnit'] as int,
      gpGoal: json['GpGoal'] as int,
      gpUnit: json['GpUnit'] as int,
      homeUp: (json['HomeUp'] as int) == 1,
      high: (json['high'] as int) == 1,
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
  final TextEditingController _homeGoalEditingController =
      TextEditingController();
  final TextEditingController _awayGoalEditingController =
      TextEditingController();
  bool _isPostponed = false;

  List<Match> matches = [];

  @override
  void initState() {
    _getToken();

    super.initState();
  }

  @override
  void dispose() {
    _homeGoalEditingController.dispose();
    _awayGoalEditingController.dispose();
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
      _fetchMatches();
    }
  }

  Future<void> _fetchMatches() async {
    var url = Uri.parse('${Config.apiUrl}/retrieve_match');
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

  Future<void> _matchStatusUpdate(int matchId) async {
    var url = Uri.parse('${Config.apiUrl}/matchupdateStatus');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          "match_id": matchId,
          "home_goals": _homeGoalEditingController.text,
          "away_goals": _awayGoalEditingController.text,
          "IsPost": _isPostponed,
        }));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success.'),
          content: const Text('Finishing match succeed.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
      await refreshPage();
    } else {
      print(response.body);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Failed.'),
          content: const Text('Finishing match failed.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getData() async {
    setState(() {
      matches.clear();
    });

    await _fetchMatches();

    _refreshController.refreshCompleted();
  }

  Future<void> refreshPage() async {
    setState(() {
      matches.clear();
    });

    await _fetchMatches();

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
// Group matches by league_name
    final Map<String, List<Match>> groupedMatches = {};
    for (var match in matches) {
      if (!groupedMatches.containsKey(match.league)) {
        groupedMatches[match.league] = [];
      }
      groupedMatches[match.league]!.add(match);
    }

    // Sort matches by time within each league
    for (var matchList in groupedMatches.values) {
      matchList.sort((a, b) {
        DateTime timeA = a.matchTime;
        DateTime timeB = b.matchTime;
        return timeB.compareTo(timeA);
      });
    }

    // Extract league names and sort them alphabetically
    List<String> sortedLeagueNames = groupedMatches.keys.toList()..sort();

    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Matches List',
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
              itemCount: sortedLeagueNames.length,
              itemBuilder: (context, index) {
                String leagueName = sortedLeagueNames[index];
                List<Match> leagueMatches = groupedMatches[leagueName]!;

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
                                child: labelText(leagueName),
                              ),
                              // Matches for the League
                              ...leagueMatches.asMap().entries.map((entry) {
                                int matchIndex = entry.key;
                                Match match = entry.value;
                                bool isLastMatch =
                                    matchIndex == leagueMatches.length - 1;
                                return radioContainer(match, isLastMatch);
                              }),
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
    );
  }

  Widget radioContainer(Match match, bool isLastMatch) {
    String formattedMatchTime =
        DateFormat("dd MMM yyyy hh:mm a").format(match.matchTime);

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
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Text(
                      'Match Time: $formattedMatchTime',
                      style: const TextStyle(color: kGrey, fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => finishedDialog(match),
                      );
                    },
                    icon: const Icon(
                      Icons.done,
                      color: kGreen,
                    ),
                    style: IconButton.styleFrom(iconSize: 20),
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
                      customRadio(match.homeTeam, 0, match.id),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            match.homeUp == true ? '<' : '',
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
                            _formatHdpGoal(match),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            match.homeUp == true ? '' : '>',
                            style: const TextStyle(
                              color: kBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      customRadio(match.awayTeam, 1, match.id),
                    ],
                  ),
                  Row(
                    children: [
                      customRadio('Over', 2, match.id),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            _formatOverUnder(match),
                          ),
                        ),
                      ),
                      customRadio('Under', 3, match.id),
                    ],
                  ),
                ],
              ),
            ),
            if (!isLastMatch)
              const Divider(), // Only render divider if not the last match
          ],
        ),
      ),
    );
  }

  String _formatHdpGoal(Match match) {
    if (match.hdpGoal == 0) {
      String sign = match.hdpUnit > 0 ? '+' : '';
      return '= $sign${match.hdpUnit}';
    } else {
      String sign = match.hdpUnit > 0 ? '+' : '';
      return '${match.hdpGoal}($sign${match.hdpUnit})';
    }
  }

  String _formatOverUnder(Match match) {
    String sign = match.gpUnit > 0 ? '+' : '';
    return '${match.gpGoal}($sign${match.gpUnit})';
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

  Widget finishedDialog(Match match) {
    // Clear the controllers when the dialog is opened
    _homeGoalEditingController.clear();
    _awayGoalEditingController.clear();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Finish Match'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Home Team: ${match.homeTeam}',
                      style: const TextStyle(color: kBlue, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Text(
                      'Away Team: ${match.awayTeam}',
                      style: const TextStyle(color: kBlue, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Checkbox(
                    value: _isPostponed,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPostponed = value!;
                      });
                    },
                  ),
                  const Text('Postpone'),
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
                      keyboardType: TextInputType.number,
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
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: materialButton(kError, 'Cancel', () {
                    Navigator.pop(context);
                  }),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'Enter', () async {
                    if (_homeGoalEditingController.text.isNotEmpty &&
                        _awayGoalEditingController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Finish Match'),
                          content: const Text(
                              'Do you really want to enter goals and finish this match?'),
                          actions: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: materialButton(kError, 'Cancel', () {
                                    Navigator.pop(context);
                                  }),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  flex: 1,
                                  child: materialButton(kBlue, 'Confirm', () {
                                    setState(() {
                                      _matchStatusUpdate(match.id);
                                    });
                                  }),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter goals for both teams.'),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

///changes
