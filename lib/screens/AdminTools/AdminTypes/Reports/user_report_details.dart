import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MatchDetail {
  final String homeTeam;
  final String awayTeam;
  final String goalScore;
  final String odd;
  final String selectedOutcome;

  MatchDetail({
    required this.homeTeam,
    required this.awayTeam,
    required this.goalScore,
    required this.odd,
    required this.selectedOutcome,
  });

  factory MatchDetail.fromJson(Map<String, dynamic> json) {
    return MatchDetail(
      homeTeam: json['home_team'],
      awayTeam: json['away_team'],
      goalScore: json['goal_score'],
      odd: json['odd'],
      selectedOutcome: json['selected_outcome'],
    );
  }
}

class UserReportDetail {
  final int betId;
  final DateTime betTime;
  final String betAmount;
  final String betStatus;
  final String winingAmount;
  final String userCommission;
  final String masterCommission;
  final List<MatchDetail> matches;

  UserReportDetail({
    required this.betId,
    required this.betTime,
    required this.betAmount,
    required this.betStatus,
    required this.winingAmount,
    required this.userCommission,
    required this.masterCommission,
    required this.matches,
  });

  factory UserReportDetail.fromJson(Map<String, dynamic> json) {
    var matchesList = (json['matches'] as List)
        .map((match) => MatchDetail.fromJson(match))
        .toList();

    return UserReportDetail(
      betId: json['bet_id'],
      betTime: DateTime.parse(json['bet_time']),
      betAmount: json['bet_amount'],
      betStatus: json['bet_status'],
      winingAmount: json['wining_amount'],
      userCommission: json['user_commission'].toString(),
      masterCommission: json['master_commission'].toString(),
      matches: matchesList,
    );
  }
}

class UserReportDetails extends StatefulWidget {
  final int betId;
  const UserReportDetails({
    required this.betId,
    super.key,
  });

  static const String id = 'user_report_details';

  @override
  State<UserReportDetails> createState() => _UserReportDetailsState();
}

class _UserReportDetailsState extends State<UserReportDetails>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final storage = const FlutterSecureStorage();

  String? _token;
  List<UserReportDetail> _reports = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchDetails(widget.betId);
    }
  }

  Future<void> _fetchDetails(int betId) async {
    var url = Uri.parse('${Config.apiUrl}/report_getBetDetail/$betId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      // Convert the JSON data to a UserReportDetail object
      UserReportDetail reportDetail = UserReportDetail.fromJson(jsonData);
      // Update the state with the fetched report detail
      setState(() {
        _reports = [reportDetail]; // Store it in the list as a single item
      });
    } else {
      print(response.body);
      // Handle error
    }
  }

  String formatBetTime(DateTime betTime) {
    // Convert the UTC bet time to Myanmar time (UTC+6:30)
    final myanmarTime = betTime.add(const Duration(hours: 6, minutes: 30));

    // Format the time in Myanmar timezone with AM/PM format
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(myanmarTime);
  }

  Widget view() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1200, // Set a maximum height for the content
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Your existing content here

            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: detailsListTitleText('Home'),
                ),
                Expanded(
                  flex: 4,
                  child: detailsListTitleText('Goal'),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: detailsListTitleText('Away')),
                ),
                Expanded(flex: 2, child: Container()),
                Expanded(
                  flex: 4,
                  child: detailsListTitleText('Goal Price'),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: detailsListTitleText('Bet Choice')),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(),
            ),
            SizedBox(
              height: 400, // Fixed height for the list view
              child: _reports.isNotEmpty
                  ? ListView.builder(
                      itemCount: _reports.length,
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: ListCard(report),
                        );
                      },
                    )
                  : const Center(
                      child: Text("No data available"),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ListCard(UserReportDetail report) {
    return Column(
      children: report.matches.map((match) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: detailsListText(
                match.selectedOutcome == match.homeTeam
                    ? "${match.homeTeam} (${match.odd})"
                    : match.homeTeam,
              ),
            ),
            Expanded(
              flex: 4,
              child: detailsListText(match.goalScore),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: detailsListText(
                  match.selectedOutcome == match.awayTeam
                      ? "${match.awayTeam} (${match.odd})"
                      : match.awayTeam,
                ),
              ),
            ),
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 4,
              child: detailsListText(
                (match.selectedOutcome == "UPPER" ||
                        match.selectedOutcome == "LOWER")
                    ? match.odd
                    : "-",
              ),
            ),
            Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.centerRight,
                child: detailsListText(match.selectedOutcome),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 5),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Column(
                  children: <Widget>[
                    _reports.isNotEmpty
                        ? Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listText('Bet ID: ${_reports.first.betId}'),
                                    listText(
                                        'Time: ${formatBetTime(_reports.first.betTime)}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listText(
                                        'Master Bet: ${_reports.first.betAmount}'),
                                    listText(
                                        'User Bet: ${_reports.first.betAmount}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listText(
                                        'Master %: ${_reports.first.masterCommission}%'),
                                    listText(
                                        'User %: ${_reports.first.userCommission}%'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listText(
                                        'Master Win: ${_reports.first.winingAmount}'),
                                    listText(
                                        'User Win: ${_reports.first.winingAmount}'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listText(
                                        'Status: ${_reports.first.betStatus}'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: Text("Loading..."),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allow horizontal scrolling
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // Fixed width
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Allow vertical scrolling
            child: Container(
              color: kPrimary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: kOnPrimaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: view(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
