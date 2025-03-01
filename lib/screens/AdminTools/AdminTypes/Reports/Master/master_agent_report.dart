import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/common_daily_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AgentReport {
  final String username;
  final String realname;
  final double turnover;
  final double validAmount;
  final double adjustedWinLoss;
  final double user;
  final double agent;
  final double adjustedWinLossWithUser;
  final double adjustedWinLossWithAgent;
  final DateTime startDate; // New field
  final DateTime endDate;
  // final String createdAt;

  AgentReport({
    required this.username,
    required this.realname,
    required this.turnover,
    required this.validAmount,
    required this.adjustedWinLoss,
    required this.user,
    required this.agent,
    required this.adjustedWinLossWithUser,
    required this.adjustedWinLossWithAgent,
    required this.startDate,
    required this.endDate,
    // required this.createdAt,
  });

  factory AgentReport.fromJson(Map<String, dynamic> json) {
    return AgentReport(
        username: json['username'] ?? '', // Default to an empty string if null
        realname: json['realname'] ?? '',
        turnover: double.tryParse(json['total_turnover'] ?? '0') ?? 0.0,
        validAmount: double.tryParse(json['total_valid_amount'] ?? '0') ?? 0.0,
        adjustedWinLoss:
            double.tryParse(json['total_adjusted_win_loss'] ?? '0') ?? 0.0,
        user: double.tryParse(json['total_master'] ?? '0') ?? 0.0,
        agent: double.tryParse(json['total_agent'] ?? '0') ?? 0.0,
        adjustedWinLossWithUser:
            double.tryParse(json['total_adjusted_win_loss_with_user'] ?? '0') ??
                0.0,
        adjustedWinLossWithAgent: double.tryParse(
                json['total_adjusted_win_loss_with_agent'] ?? '0') ??
            0.0,
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date'])
        // createdAt: json['created_at'] ?? '',
        );
  }
}

class Master_agent_report extends StatefulWidget {
  static const String id = 'agent_daily_report';
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const Master_agent_report({
    super.key,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<Master_agent_report> createState() => _AgentDailyReportState();
}

class _AgentDailyReportState extends State<Master_agent_report>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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
      await _fetchAgentReportWithDate(
          widget.name, widget.startDate, widget.endDate);
    }
  }

  Future<void> _fetchAgentReportWithDate(
      String name, DateTime? start, DateTime? end) async {
    if (start == null || end == null || _token == null) {
      return; // Ensure the dates and token are set before making the request
    }
    var url = Uri.parse(
        '${Config.apiUrl}/master_agentReportWithDate/$name?start_date=${start.toIso8601String()}&end_date=${end.toIso8601String()}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List<dynamic> reportsData = jsonResponse['data'];
      setState(() {
        _reports =
            reportsData.map((json) => AgentReport.fromJson(json)).toList();
      });
    } else {
      print(response.body);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
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
    double totalTurnover = _reports.fold(0, (sum, item) => sum + item.turnover);
    double totalValidAmount =
        _reports.fold(0, (sum, item) => sum + item.validAmount);
    double totalAdjustedWinLoss =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLoss);
    double totalUserCom = _reports.fold(0, (sum, item) => sum + item.user);
    double totalAgentCom = _reports.fold(0, (sum, item) => sum + item.agent);
    double winLossWithAgent =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLossWithAgent);
    double winLossWithUser =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLossWithUser);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
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
                const VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      detailsListTitleText('Master'),
                      const Divider(),
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
                const VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      detailsListTitleText('Agent'),
                      const Divider(),
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
                const VerticalDivider(),
                Expanded(flex: 4, child: detailsListTitleText('View Details')),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(),
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
                  : const Center(child: Text("No data available")),
            ),
            TotalRow(
              totalTurnover: totalTurnover,
              totalValidAmount: totalValidAmount,
              totalAdjustedWinLoss: totalAdjustedWinLoss,
              totalUserCom: totalUserCom,
              totalAgentCom: totalAgentCom,
              winLossWithAgent: winLossWithAgent,
              winLossWithUser: winLossWithUser,
            ),
          ],
        ),
      ),
    );
  }

  Widget TotalRow({
    required double totalTurnover,
    required double totalValidAmount,
    required double totalAdjustedWinLoss,
    required double totalUserCom,
    required double totalAgentCom,
    required double winLossWithAgent,
    required double winLossWithUser,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: detailsListText('Total'),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(''),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(totalTurnover.toStringAsFixed(2)),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(totalValidAmount.toStringAsFixed(2)),
        ),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                  child:
                      detailsListText(totalAdjustedWinLoss.toStringAsFixed(2))),
              Expanded(
                  child: detailsListText(totalAgentCom
                      .toStringAsFixed(2))), // Placeholder for other columns
              Expanded(
                child: detailsListText(winLossWithAgent.toStringAsFixed(2)),
              )
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                  child:
                      detailsListText(totalAdjustedWinLoss.toStringAsFixed(2))),
              Expanded(child: detailsListText(totalUserCom.toStringAsFixed(2))),
              Expanded(
                child: detailsListText(
                  winLossWithUser.toStringAsFixed(2),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          flex: 4,
          child: SizedBox(), // Empty for view details column
        ),
      ],
    );
  }

  Widget ListCard(AgentReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: detailsListText(report.username)),
        Expanded(flex: 5, child: detailsListText(report.realname)),
        Expanded(
            flex: 5,
            child: detailsListText(report.turnover.toStringAsFixed(2))),
        Expanded(
            flex: 5,
            child: detailsListText(report.validAmount.toStringAsFixed(2))),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                  child: detailsListText(
                      report.adjustedWinLoss.toStringAsFixed(2))),
              Expanded(child: detailsListText(report.agent.toStringAsFixed(2))),
              Expanded(
                  child: detailsListText(
                      report.adjustedWinLossWithAgent.toStringAsFixed(2))),
            ],
          ),
        ),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              Expanded(
                  child: detailsListText(
                      report.adjustedWinLoss.toStringAsFixed(2))),
              Expanded(child: detailsListText(report.user.toStringAsFixed(2))),
              Expanded(
                  child: detailsListText(
                      report.adjustedWinLossWithAgent.toStringAsFixed(2))),
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
                  builder: (context) => CommonDailyReport(
                    name: report.username,
                    startDate: report.startDate,
                    endDate: report.endDate,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.remove_red_eye_outlined, size: 15),
          ),
        ),
      ],
    );
  }
}
