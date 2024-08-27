import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting/checkRow.dart';
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
    );
  }
}

class MaungBetting extends StatefulWidget {
  static const String id = 'maung_betting';
  const MaungBetting({super.key});

  @override
  State<MaungBetting> createState() => _MaungBettingState();
}

class _MaungBettingState extends State<MaungBetting> {
  final storage = const FlutterSecureStorage();
  String? _token;
  double? _balance;
  Map<int, String> selectedValues = {};
  List<Match> matches = [];
  List<Match> filteredMatches = [];
  Map<String, bool> selectedLeagues = {};
  int? _maxMixBet;
  String? _username;
  final TextEditingController _maungBettingEditingController =
      TextEditingController();

  static const int minSelect = 2;
  static const int maxSelect = 11;

  @override
  void initState() {
    _username = 'Loading...';
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    _maungBettingEditingController.dispose();
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
    final String? username = await storage.read(key: 'user_name');
    if (username != null) {
      setState(() {
        _username = username;
      });
    }
    if (_token != null) {
      _fetchMatches();
      _getBalance();
    }
    if (_token != null && _username != null) {
      _getMaxBetAmount(_username!);
    }
  }

  Future<void> _getMaxBetAmount(String username) async {
    var url = Uri.parse('${Config.apiUrl}/maxAmountBets/$username');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _maxMixBet = data['maxMixBet'];
      });
    } else {}
  }

  Future<void> _getBalance() async {
    var url = Uri.parse('${Config.apiUrl}/get_balance');
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
    var url = Uri.parse('${Config.apiUrl}/retrieve_match');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      setState(() {
        matches = jsonResponse.map((match) => Match.fromJson(match)).toList();
        filteredMatches = matches;
        _initLeagues();
      });
    } else {}
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getData() async {
    // Fetch new matches data
    await _fetchMatches();

    // Indicate that the refresh process is completed
    _refreshController.refreshCompleted();
  }

  void _initLeagues() {
    Set<String> uniqueLeagues = matches.map((match) => match.league).toSet();
    selectedLeagues = {for (var league in uniqueLeagues) league: false};
  }

  void _applyFilters() {
    setState(() {
      if (selectedLeagues.containsValue(true)) {
        filteredMatches = matches.where((match) {
          return selectedLeagues[match.league] ?? false;
        }).toList();
      } else {
        filteredMatches = matches;
      }
    });
  }

  Future<void> refreshPage() async {
    Map<String, bool> previousSelectedLeagues = Map.from(selectedLeagues);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    setState(() {
      matches.clear();
    });

    await _fetchMatches();

    setState(() {
      selectedLeagues = previousSelectedLeagues;

      _applyFilters();
    });

    Navigator.pop(context);

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          centerTitle: true,
          title: const Text(
            'Maung Betting',
            style: TextStyle(
              color: kBlack,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    refreshPage();
                  });
                },
                icon: Icon(Icons.refresh_outlined)),
            IconButton(
              icon: const Icon(Icons.sort),
              color: kBlack,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setDialogState) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Expanded(
                                child:
                                    Text('${selectedLeagues.length} Leagues'),
                              ),
                              Expanded(child: Container()), // Spacer
                              Expanded(
                                child: CheckRow(
                                  label: selectedLeagues.values.every((v) => v)
                                      ? 'Uncheck All'
                                      : 'Check All',
                                  value: selectedLeagues.values.every((v) => v),
                                  onChanged: (bool? value) {
                                    setDialogState(() {
                                      // Update all checkboxes in the dialog
                                      selectedLeagues
                                          .updateAll((key, val) => value!);
                                      // Trigger a rebuild in the parent widget
                                      setState(() {
                                        _applyFilters();
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: selectedLeagues.keys.map((league) {
                                return CheckRow(
                                  label: league,
                                  value: selectedLeagues[league]!,
                                  onChanged: (bool? value) {
                                    setDialogState(() {
                                      // Update the specific league checkbox
                                      selectedLeagues[league] = value!;
                                      // Trigger a rebuild in the parent widget
                                      setState(() {
                                        _applyFilters();
                                      });
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                const SizedBox(width: 5.0),
                                Expanded(
                                  flex: 1,
                                  child: materialButton(kBlue, 'Close', () {
                                    // Trigger filters before closing the dialog
                                    // setState(() {
                                    //   _applyFilters();
                                    // });
                                    Navigator.pop(context);
                                  }),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
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
                  flex: 2,
                  child: Text('Maung ( ${selectedValues.length} )'),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    controller: _maungBettingEditingController,
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
                    String text = _maungBettingEditingController.text;
                    double amount = double.tryParse(text) ?? 0.0;

                    // Check if the input amount is numeric
                    if (text.isEmpty || amount < 1000) {
                      // Show dialog for invalid bet amount
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Invalid Bet Amount'),
                          content: const Text(
                              'Please enter a valid numeric amount to bet.'),
                          actions: <Widget>[
                            materialButton(kError, 'OK', () {
                              Navigator.pop(context);
                            }),
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
                            materialButton(kError, 'OK', () {
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                      );
                      return;
                    }

                    // Check if user has selected a match
                    if (selectedValues.isEmpty) {
                      // Show dialog for no match selected
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('No Match Selected'),
                          content: const Text(
                              'Please select a match before placing the bet.'),
                          actions: <Widget>[
                            materialButton(kError, 'OK', () {
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                      );
                      return;
                    }
                    if (_balance != null && amount > _maxMixBet!) {
                      // Show dialog for no match selected
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content:
                              const Text('You cannot bet more than limit.'),
                          actions: <Widget>[
                            materialButton(kError, 'OK', () {
                              Navigator.pop(context);
                            }),
                          ],
                        ),
                      );
                      return;
                    }
                    // Both conditions are met, show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Bet'),
                        content: Text(
                            'Do you want to bet $text amount for maung(${selectedValues.length}) matches?'),
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
                                  // Check if user has selected the correct number of matches
                                  if (selectedValues.length < minSelect ||
                                      selectedValues.length > maxSelect) {
                                    // Show dialog for invalid number of matches selected
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            'Invalid Number of Matches Selected.'),
                                        content: const Text(
                                            'Please select between $minSelect and $maxSelect matches before placing the bet.'),
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
                                                child: materialButton(
                                                    kBlue, 'OK', () {
                                                  Navigator.pop(context);
                                                }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  } else {
                                    _placeAccumulatorBet(amount);
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
        ));
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
          onRefresh: () => refreshPage(),
          child: ListView.builder(
              padding: const EdgeInsets.all(5.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
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
    DateTime now = DateTime.now();
    bool matchStarted = now.isAfter(match.matchTime);
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
            labelText(match.league),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Match Time: ${DateFormat("dd MMM yyyy hh:mm a").format(match.matchTime)}',
                      style: const TextStyle(color: kGrey, fontSize: 12),
                    ),
                  ),
                  Row(
                    children: [
                      customRadio(match.homeTeam, 0, index, matchStarted),
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
                            style: TextStyle(fontSize: 10),
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
                      customRadio(match.awayTeam, 1, index, matchStarted),
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
                            _formatOverUnder(match),
                            style: TextStyle(fontSize: 10),
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

  Widget customRadio(
      String item, int itemIndex, int listIndex, bool matchStarted) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: matchStarted
              ? null
              : () {
                  setState(() {
                    if (selectedValues[listIndex] == item) {
                      selectedValues.remove(listIndex); // Unselect
                    } else {
                      if (selectedValues.length < maxSelect) {
                        selectedValues[listIndex] =
                            item; // Select the tapped item
                      }
                    }
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
                  fontSize: 10,
                  color: selectedValues[listIndex] == item ? kWhite : kBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _placeAccumulatorBet(double amount) async {
    List<Map<String, dynamic>> accumulatorData =
        selectedValues.entries.map((entry) {
      int matchId = matches[entry.key].id;
      String selectedOutcome = entry.value;
      if (selectedOutcome == matches[entry.key].homeTeam) {
        selectedOutcome = 'W1';
      } else if (selectedOutcome == matches[entry.key].awayTeam) {
        selectedOutcome = 'W2';
      }
      return {
        'match_id': matchId,
        'selected_outcome': selectedOutcome,
      };
    }).toList();

    var url = Uri.parse('${Config.apiUrl}/add_maung_matches');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'amount': amount,
        'matches': accumulatorData,
      }),
    );

    if (response.statusCode == 200) {
      _getBalance();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Succeed.'),
          content: const Text('Betting ucceed.'),
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
        _maungBettingEditingController.clear();
        setState(() {
          selectedValues.clear(); // Clear the selected values
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
