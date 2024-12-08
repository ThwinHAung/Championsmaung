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
  static const String id = 'common_daily_report';
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
        'Accept': 'Application/json'
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
    double totalTurnover = _reports.fold(0, (sum, item) => sum + item.turnover);
    double totalValidAmount =
        _reports.fold(0, (sum, item) => sum + item.validAmount);
    double totalAdjustedWinLoss =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLoss);
    double totalMasterCom = _reports.fold(0, (sum, item) => sum + item.master);
    double totalAgentCom = _reports.fold(0, (sum, item) => sum + item.agent);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: TotalRow(
                totalTurnover: totalTurnover,
                totalValidAmount: totalValidAmount,
                totalAdjustedWinLoss: totalAdjustedWinLoss,
                totalMasterCom: totalMasterCom,
                totalAgentCom: totalAgentCom,
              ),
            ),
          ],
        ));
  }

  Widget view() {
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
              Expanded(
                  child: detailsListText(report.master.toStringAsFixed(2))),
              Expanded(
                  child: detailsListText(
                      (report.adjustedWinLoss + report.master)
                          .toStringAsFixed(2))),
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
              Expanded(child: detailsListText(report.agent.toStringAsFixed(2))),
              Expanded(
                  child: detailsListText((report.agent + report.adjustedWinLoss)
                      .toStringAsFixed(2))),
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
            icon: const Icon(Icons.remove_red_eye_outlined, size: 15),
          ),
        ),
      ],
    );
  }

  Widget TotalRow({
    required double totalTurnover,
    required double totalValidAmount,
    required double totalAdjustedWinLoss,
    required double totalMasterCom,
    required double totalAgentCom,
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
                  child: detailsListText(totalMasterCom
                      .toStringAsFixed(2))), // Placeholder for other columns
              Expanded(
                child: detailsListText(
                    (totalAdjustedWinLoss + totalMasterCom).toStringAsFixed(2)),
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
              Expanded(
                  child: detailsListText(totalAgentCom.toStringAsFixed(2))),
              Expanded(
                child: detailsListText(
                  (totalAdjustedWinLoss + totalAgentCom).toStringAsFixed(2),
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
}
