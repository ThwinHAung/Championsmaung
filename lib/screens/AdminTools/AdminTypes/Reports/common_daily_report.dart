import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/user_report_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AgentReport {
  final String username;
  final String realname;
  final double turnover;
  final double validAmount;
  final double adjustedWinLoss;
  final double master;
  final double agent;
  final int betId;

  AgentReport({
    required this.username,
    required this.realname,
    required this.turnover,
    required this.validAmount,
    required this.adjustedWinLoss,
    required this.master,
    required this.agent,
    required this.betId,
  });

  factory AgentReport.fromJson(Map<String, dynamic> json) {
    return AgentReport(
      username: json['username'],
      realname: json['realname'],
      turnover: double.parse(json['turnover']),
      validAmount: double.parse(json['valid_amount']),
      adjustedWinLoss: double.parse(json['adjusted_win_loss']),
      master: double.parse(json['master']),
      agent: double.parse(json['agent']),
      betId: json['bet_id'],
    );
  }
}

class CommonDailyReport extends StatefulWidget {
  static const String id = 'agent_daily_report';
  final String name;
  final String date;

  const CommonDailyReport({super.key, required this.name, required this.date});

  @override
  State<CommonDailyReport> createState() => _AgentDailyReportState();
}

class _AgentDailyReportState extends State<CommonDailyReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int? userId;
  final storage = const FlutterSecureStorage();
  String? _token;
  List<AgentReport> _reports = [];
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  Future<void> _fetchAgentReport(
      int agentId, DateTime? start, DateTime? end) async {
    if (start == null || end == null || _token == null) {
      return; // Ensure the dates and token are set before making the request
    }
    var url = Uri.parse(
        '${Config.apiUrl}/agentReport?start_date=${startDate!.toIso8601String()}&end_date=${endDate!.toIso8601String()}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> reportsData = jsonResponse['data'];
      _reports = reportsData.map((json) => AgentReport.fromJson(json)).toList();
      setState(() {});
    } else {
      print(response.body);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: materialButton(kBlue,
                                '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : ''} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : 'Choose Date Range'}',
                                () {
                              _selectDateRange(context);
                            })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            flex: 3,
                            child: IconButton(
                                onPressed: () {
                                  _fetchAgentReport(1, startDate!, endDate!);
                                },
                                icon: const Icon(
                                  Icons.search_outlined,
                                  color: kBlue,
                                )))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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

  Widget view() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: detailsListTitleText('Account')),
                Expanded(flex: 5, child: detailsListTitleText('Contact')),
                Expanded(flex: 5, child: detailsListTitleText('Turnover')),
                Expanded(flex: 5, child: detailsListTitleText('Valid Amount')),
                VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      detailsListTitleText('Master'),
                      Divider(),
                      Row(
                        children: [
                          Expanded(child: detailsListTitleText('W/L')),
                          Expanded(child: detailsListTitleText('Com')),
                          Expanded(child: detailsListTitleText('W/L + Com')),
                        ],
                      ),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      detailsListTitleText('Agent'),
                      Divider(),
                      Row(
                        children: [
                          Expanded(child: detailsListTitleText('W/L')),
                          Expanded(child: detailsListTitleText('Com')),
                          Expanded(child: detailsListTitleText('W/L + Com')),
                        ],
                      ),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(flex: 4, child: detailsListTitleText('View Details')),
              ],
            ),
            const SizedBox(height: 10.0),
            Divider(),
            SizedBox(
              height: 400,
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

  Widget ListCard(AgentReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: detailsListText(report.username)),
        Expanded(flex: 5, child: detailsListText(report.realname)),
        Expanded(flex: 5, child: detailsListText('${report.turnover}')),
        Expanded(flex: 5, child: detailsListText('${report.validAmount}')),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(child: detailsListText('${report.adjustedWinLoss}')),
              Expanded(child: detailsListText('${report.master}')),
              Expanded(
                  child: detailsListText(
                      '${report.adjustedWinLoss + report.master}')),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(child: detailsListText('${report.adjustedWinLoss}')),
              Expanded(child: detailsListText('${report.agent}')),
              Expanded(
                  child: detailsListText(
                      '${report.agent + report.adjustedWinLoss}')),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserReportDetails(betId: report.betId),
                ),
              );
            },
            icon: Icon(Icons.remove_red_eye_outlined, size: 15),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(Duration(days: 30)),
        end: endDate ?? DateTime.now(),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedRange != null) {
      setState(() {
        startDate = selectedRange.start;
        endDate = selectedRange.end;
      });
    }
  }
}
