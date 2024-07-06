import 'dart:convert';

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
  final storage = const FlutterSecureStorage();
  String? _token;
  double? _balance;
  int? selectedMatchIndex;
  String? selectedOutcome;
  List<Match> matches = [];

  final TextEditingController _bodyBettingEditingController =
      TextEditingController();

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    _bodyBettingEditingController.dispose();
    super.dispose();
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
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimary,
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
                  double amount = double.tryParse(text) ?? 0.0;

                  // Check if the input amount is numeric
                  if (text.isEmpty || amount <= 0) {
                    // Show dialog for invalid bet amount
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Invalid Bet Amount'),
                        content: const Text('Please Enter valid amount'),
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
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    return;
                  }

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
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  // All conditions are met, show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Bet'),
                      content: Text('Do you want to bet $text units?'),
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
                              child: materialButton(kBlue, 'Bet', () {
                                if (selectedMatchIndex != null &&
                                    selectedOutcome != null) {
                                  int matchId = matches[selectedMatchIndex!].id;
                                  _placeSingleBet(
                                      matchId, selectedOutcome!, amount);
                                }
                              }),
                            )
                          ],
                        )
                      ],
                    ),
                  );
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
            padding: const EdgeInsets.all(10.0),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: matches.length, // Use matches.length
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                delay: const Duration(milliseconds: 100),
                child: SlideAnimation(
                  verticalOffset:
                      50.0, // Adjust the vertical offset for sliding effect
                  duration: const Duration(
                      milliseconds: 500), // Adjust the duration for smoothness
                  curve: Curves.easeInOut, // Use a smooth curve
                  child: FadeInAnimation(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child:
                          radioContainer(index), // Use index to access matches
                    ),
                  ),
                ),
              );
            },
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
    DateTime now = DateTime.now();
    // Check if the match has started
    bool matchStarted = now.isAfter(matchTime);
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
            labelText(match.league_name),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Match Time: $formattedMatchTime',
                      style: const TextStyle(color: kGrey, fontSize: 12),
                    ),
                  ),
                  Row(
                    children: [
                      customRadio(match.homeMatch, 0, index, matchStarted),
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
                      customRadio(match.awayMatch, 1, index, matchStarted),
                    ],
                  ),
                  Row(
                    children: [
                      customRadio("Over", 2, index, matchStarted),
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
                      customRadio("Under", 3, index, matchStarted),
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

  Widget customRadio(
      String item, int itemIndex, int listIndex, bool matchStarted) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: matchStarted
              ? null
              : () {
                  setState(() {
                    if (selectedMatchIndex == listIndex &&
                        selectedOutcome == item) {
                      // Deselect if the same item is tapped
                      selectedMatchIndex = null;
                      selectedOutcome = null;
                    } else {
                      // Clear previous selection and select the new one
                      selectedMatchIndex = listIndex;
                      selectedOutcome = item;
                    }
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selectedMatchIndex == listIndex && selectedOutcome == item
                  ? kBlue
                  : kPrimary,
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                item,
                style: TextStyle(
                  color:
                      selectedMatchIndex == listIndex && selectedOutcome == item
                          ? kWhite
                          : kBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _placeSingleBet(
      int matchId, String selectedTeam, double amount) async {
    Match? selectedMatch = matches.firstWhere(
      (match) => match.id == matchId,
      orElse: () => null as Match,
    );

    String? selectedOutcome;
    if (selectedMatch.homeMatch == selectedTeam) {
      selectedOutcome = 'W1';
    } else if (selectedMatch.awayMatch == selectedTeam) {
      selectedOutcome = 'W2';
    } else if (selectedTeam == 'Over') {
      selectedOutcome = 'Over';
    } else if (selectedTeam == 'Under') {
      selectedOutcome = 'Under';
    }
    print(selectedOutcome);
    var url = Uri.parse('http://127.0.0.1:8000/api/add_body_match');
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    }, body: {
      'match_id': matchId.toString(),
      'selected_outcome': selectedOutcome,
      'amount': amount.toString(),
    });
    if (response.statusCode == 200) {
      _getBalance();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Succeed.'),
          content: const Text('Betting Succeed.'),
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
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {
        _bodyBettingEditingController.clear();
        setState(() {
          selectedMatchIndex = null;
          selectedOutcome = null;
        });
        // Navigate back after dialog is closed
        Navigator.pop(context);
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> errors = responseData['errors'];
      String errorMessage = "";
      errors.forEach((key, value) {
        errorMessage += "$key: $value\n";
      });

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Failed to bet'),
          content: Text(errorMessage),
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
                    }))
              ],
            ),
          ],
        ),
      );
    }
  }
}
