import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/user_report_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
  final DateTime startDate;
  final DateTime endDate;

  const CommonDailyReport({
    super.key,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<CommonDailyReport> createState() => _AgentDailyReportState();
}

class _AgentDailyReportState extends State<CommonDailyReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int? userId;
  final storage = const FlutterSecureStorage();
  String? _token;
  List<AgentReport> _reports = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchAgentReport(widget.name, widget.startDate, widget.endDate);
    }
  }

  Future<void> _fetchAgentReport(
      String name, DateTime? start, DateTime? end) async {
    var url = Uri.parse(
        '${Config.apiUrl}/agentReport/$name?start_date=${start!.toIso8601String()}&end_date=${end!.toIso8601String()}');
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
}
