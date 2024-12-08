import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/common_daily_report.dart';
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
  final DateTime startDate; // New field
  final DateTime endDate;
  // final String createdAt;

  AgentReport({
    required this.username,
    required this.realname,
    required this.turnover,
    required this.validAmount,
    required this.adjustedWinLoss,
    required this.master,
    required this.agent,
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
        master: double.tryParse(json['total_master'] ?? '0') ?? 0.0,
        agent: double.tryParse(json['total_agent'] ?? '0') ?? 0.0,
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date'])
        // createdAt: json['created_at'] ?? '',
        );
  }
}

class AgentDailyReport extends StatefulWidget {
  static const String id = 'agent_daily_report';

  const AgentDailyReport({
    super.key,
  });

  @override
  State<AgentDailyReport> createState() => _AgentDailyReportState();
}

class _AgentDailyReportState extends State<AgentDailyReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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
    if (_token != null) {
      await _fetchAgentReport();
    }
  }

  Future<void> _fetchAgentReportWithDate(DateTime? start, DateTime? end) async {
    if (start == null || end == null || _token == null) {
      return; // Ensure the dates and token are set before making the request
    }
    var url = Uri.parse(
        '${Config.apiUrl}/agentReportGroupWithDate?start_date=${startDate!.toIso8601String()}&end_date=${endDate!.toIso8601String()}');
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

  Future<void> _fetchAgentReport() async {
    var url = Uri.parse('${Config.apiUrl}/agentReportGroup');
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
                                  _fetchAgentReportWithDate(
                                      startDate!, endDate!);
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
    double totalTurnover = _reports.fold(0, (sum, item) => sum + item.turnover);
    double totalValidAmount =
        _reports.fold(0, (sum, item) => sum + item.validAmount);
    double totalAdjustedWinLoss =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLoss);
    double totalMasterCom = _reports.fold(0, (sum, item) => sum + item.master);
    double totalAgentCom = _reports.fold(0, (sum, item) => sum + item.agent);

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
                  : const Center(child: Text("No data available")),
            ),
            TotalRow(
                totalTurnover: totalTurnover,
                totalValidAmount: totalValidAmount,
                totalAdjustedWinLoss: totalAdjustedWinLoss,
                totalMasterCom: totalMasterCom,
                totalAgentCom: totalAgentCom),
          ],
        ),
      ),
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
        Expanded(
          flex: 4,
          child: const SizedBox(), // Empty for view details column
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
                  builder: (context) => CommonDailyReport(
                    name: report.username,
                    startDate: report.startDate,
                    endDate: report.endDate,
                  ),
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
      firstDate: DateTime(2021),
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
