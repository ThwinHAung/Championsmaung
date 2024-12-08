import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/SSenior/ssenior_senior_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SSeniorReport {
  final String seniorUsername;
  final String seniorRealname;
  final double totalTurnover;
  final double totalValidAmount;
  final double totalWinLoss;
  final double totalSeniorCommission;
  final double totalSSeniorCommission;
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
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']));
  }
}

class SSeniorDailyReport extends StatefulWidget {
  static const String id = 'ssenior_daily_report';

  const SSeniorDailyReport({
    super.key,
  });

  @override
  State<SSeniorDailyReport> createState() => _SSeniorDailyReportState();
}

class _SSeniorDailyReportState extends State<SSeniorDailyReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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
      _fetchSSeniorReport();
    }
  }

  Future<void> _fetchSSeniorReport() async {
    var url = Uri.parse('${Config.apiUrl}/sseniorReport');
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
            reportsData.map((json) => SSeniorReport.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }

  Future<void> _fetchSSeniorReportWithDate(
      DateTime? start, DateTime? end) async {
    var url = Uri.parse(
        '${Config.apiUrl}/sseniorReportWithDate?start_date=${startDate!.toIso8601String()}&end_date=${endDate!.toIso8601String()}');
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
            reportsData.map((json) => SSeniorReport.fromJson(json)).toList();
      });
    } else {
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
                                  _fetchSSeniorReportWithDate(
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
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
                VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      detailsListTitleText('SSenior'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                VerticalDivider(),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      detailsListTitleText('Senior'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                VerticalDivider(),
                Expanded(
                  flex: 4,
                  child: detailsListTitleText('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            TotalRow(
                totalTurnover: totalTurnover,
                totalValidAmount: totalValidAmount,
                totalAdjustedWinLoss: totalAdjustedWinLoss,
                totalSSeniorCom: totalSSeniorCom,
                totalSeniorCom: totalSeniorCom),
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
                child: detailsListText((totalAdjustedWinLoss + totalSSeniorCom)
                    .toStringAsFixed(2)),
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
                  (totalAdjustedWinLoss + totalSeniorCom).toStringAsFixed(2),
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
                      (report.totalWinLoss + report.totalSSeniorCommission)
                          .toStringAsFixed(2)),
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
                      (report.totalWinLoss + report.totalSeniorCommission)
                          .toStringAsFixed(2)),
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
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  size: 15,
                )),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(const Duration(days: 30)),
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
