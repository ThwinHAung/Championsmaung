import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/SSenior/ssenior_senior_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SSeniorReport {
  final String seniorUsername;
  final String seniorRealname;
  final double totalTurnover;
  final double totalValidAmount;
  final double totalWinLoss;
  final double totalSeniorCommission;
  final double totalSSeniorCommission;
  final double adjustedWinLossWithSSenior;
  final double adjustedWinLossWithSenior;
  final DateTime startDate; // New field
  final DateTime endDate;

  SSeniorReport({
    required this.seniorUsername,
    required this.seniorRealname,
    required this.totalTurnover,
    required this.totalValidAmount,
    required this.totalWinLoss,
    required this.totalSeniorCommission,
    required this.totalSSeniorCommission,
    required this.adjustedWinLossWithSSenior,
    required this.adjustedWinLossWithSenior,
    required this.startDate,
    required this.endDate,
  });

  factory SSeniorReport.fromJson(Map<String, dynamic> json) {
    return SSeniorReport(
        seniorUsername: json['senior_username'] ?? '',
        seniorRealname: json['senior_realname'] ?? '',
        totalTurnover: double.tryParse(json['total_turnover'] ?? '0') ?? 0.0,
        totalValidAmount:
            double.tryParse(json['total_valid_amount'] ?? '0') ?? 0.0,
        totalWinLoss: double.tryParse(json['total_win_loss'] ?? '0') ?? 0.0,
        totalSeniorCommission:
            double.tryParse(json['total_senior_commission'] ?? '0') ?? 0.0,
        totalSSeniorCommission:
            double.tryParse(json['total_ssenior_commission'] ?? '0') ?? 0.0,
        adjustedWinLossWithSSenior: double.tryParse(
                json['total_adjusted_win_loss_with_ssenior'] ?? '0') ??
            0.0,
        adjustedWinLossWithSenior: double.tryParse(
                json['total_adjusted_win_loss_with_senior'] ?? '0') ??
            0.0,
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']));
  }
}

class Sssenior_SseniorReport extends StatefulWidget {
  static const String id = 'sssenior_daily_report';
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const Sssenior_SseniorReport({
    super.key,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<Sssenior_SseniorReport> createState() => _SSSeniorDailyReportState();
}

class _SSSeniorDailyReportState extends State<Sssenior_SseniorReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int? userId;
  final storage = const FlutterSecureStorage();
  String? _token;

  DateTime? startDate;
  DateTime? endDate;
  List<SSeniorReport> _reports = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchReport(widget.name, widget.startDate, widget.endDate);
    }
  }

  Future<void> _fetchReport(
      String? name, DateTime? start, DateTime? end) async {
    if (start == null || end == null || _token == null) {
      return; // Ensure the dates and token are set before making the request
    }
    var url = Uri.parse(
        '${Config.apiUrl}/sssenior_sseniorReport/$name?start_date=${start.toIso8601String()}&end_date=${end.toIso8601String()}');

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
      _reports =
          reportsData.map((json) => SSeniorReport.fromJson(json)).toList();
      setState(() {});
    } else {
      // Handle error
      print(response.body);
      print('Failed to load reports');
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

  Widget view() {
    double totalTurnover =
        _reports.fold(0, (sum, item) => sum + item.totalTurnover);
    double totalValidAmount =
        _reports.fold(0, (sum, item) => sum + item.totalValidAmount);
    double totalAdjustedWinLoss =
        _reports.fold(0, (sum, item) => sum + item.totalWinLoss);
    double totalSeniorCom =
        _reports.fold(0, (sum, item) => sum + item.totalSeniorCommission);
    double totalSSeniorCom =
        _reports.fold(0, (sum, item) => sum + item.totalSSeniorCommission);
    double winLossWithSSenior =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLossWithSSenior);
    double winLossWithSenior =
        _reports.fold(0, (sum, item) => sum + item.adjustedWinLossWithSenior);
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
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: detailsListTitleText('Account'),
                ),
                Expanded(
                  flex: 5,
                  child: detailsListTitleText('Contact'),
                ),
                Expanded(
                  flex: 5,
                  child: detailsListTitleText('Turnover'),
                ),
                Expanded(
                  flex: 5,
                  child: detailsListTitleText('Valid Amount'),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      detailsListTitleText('SSSenior'),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: detailsListTitleText('W/L'),
                          ),
                          Expanded(
                            child: detailsListTitleText('Com'),
                          ),
                          Expanded(
                            child: detailsListTitleText('W/L + Com'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      detailsListTitleText('SSenior'),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: detailsListTitleText('W/L'),
                          ),
                          Expanded(
                            child: detailsListTitleText('Com'),
                          ),
                          Expanded(
                            child: detailsListTitleText('W/L + Com'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 4,
                  child: detailsListTitleText('View Details'),
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
                  : const Center(child: Text("No data available")),
            ),
            TotalRow(
              totalTurnover: totalTurnover,
              totalValidAmount: totalValidAmount,
              totalAdjustedWinLoss: totalAdjustedWinLoss,
              totalSSeniorCom: totalSSeniorCom,
              totalSeniorCom: totalSeniorCom,
              winLossWithSSenior: winLossWithSSenior,
              winLossWithSenior: winLossWithSenior,
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
    required double totalSSeniorCom,
    required double totalSeniorCom,
    required double winLossWithSSenior,
    required double winLossWithSenior,
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
                  child: detailsListText(totalSSeniorCom
                      .toStringAsFixed(2))), // Placeholder for other columns
              Expanded(
                child: detailsListText(winLossWithSSenior.toStringAsFixed(2)),
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
                  child: detailsListText(totalSeniorCom.toStringAsFixed(2))),
              Expanded(
                child: detailsListText(
                  winLossWithSenior.toStringAsFixed(2),
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

  Widget ListCard(SSeniorReport report) {
    // String formattedDate =
    //     DateFormat('yyyy-MM-dd hh:mm a').format(transaction.date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: detailsListText(report.seniorUsername),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.seniorRealname),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.totalTurnover.toStringAsFixed(2)),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.totalValidAmount.toStringAsFixed(2)),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Expanded(
                  child:
                      detailsListText(report.totalWinLoss.toStringAsFixed(2)),
                ),
                Expanded(
                  child: detailsListText(
                      report.totalSSeniorCommission.toStringAsFixed(2)),
                ),
                Expanded(
                  child: detailsListText(
                      report.adjustedWinLossWithSSenior.toStringAsFixed(2)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Expanded(
                  child:
                      detailsListText(report.totalWinLoss.toStringAsFixed(2)),
                ),
                Expanded(
                  child: detailsListText(
                      report.totalSeniorCommission.toStringAsFixed(2)),
                ),
                Expanded(
                  child: detailsListText(
                      report.adjustedWinLossWithSenior.toStringAsFixed(2)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SseniorSeniorReport(
                        name: report.seniorUsername,
                        startDate: report.startDate,
                        endDate: report.endDate,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 15,
                )),
          ),
        ),
      ],
    );
  }

  Widget detailsListText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12.0,
      ),
    );
  }

  Widget detailsListTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget materialButton(Color color, String text, VoidCallback onPressed) {
    return MaterialButton(
      color: color,
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
