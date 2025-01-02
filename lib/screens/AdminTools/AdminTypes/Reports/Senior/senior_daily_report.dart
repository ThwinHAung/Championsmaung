import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/Senior/senior_master_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SeniorReport {
  final String masterUsername;
  final String masterRealname;
  final double totalTurnover;
  final double totalValidAmount;
  final double totalWinLoss;
  final double totalSeniorCommission;
  final double totalSSeniorCommission;
  final double adjustedWinLossWithSSenior;
  final double adjustedWinLossWithSenior;
  final DateTime startDate; // New field
  final DateTime endDate;

  SeniorReport({
    required this.masterUsername,
    required this.masterRealname,
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

  factory SeniorReport.fromJson(Map<String, dynamic> json) {
    return SeniorReport(
        masterUsername: json['master_username'] ?? '',
        masterRealname: json['master_realname'] ?? '',
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

class SeniorDailyReport extends StatefulWidget {
  static const String id = 'senior_daily_report';

  const SeniorDailyReport({
    super.key,
  });

  @override
  State<SeniorDailyReport> createState() => _SeniorDailyReportState();
}

class _SeniorDailyReportState extends State<SeniorDailyReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final storage = const FlutterSecureStorage();
  String? _token;

  DateTime? startDate;
  DateTime? endDate;
  List<SeniorReport> _reports = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchSeniorReport();
    }
  }

  Future<void> _fetchSeniorReport() async {
    var url = Uri.parse('${Config.apiUrl}/seniorReport');
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
            reportsData.map((json) => SeniorReport.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }

  Future<void> _fetchSeniorReportWithDate(
      DateTime? start, DateTime? end) async {
    var url = Uri.parse(
        '${Config.apiUrl}/seniorReportWithDate?start_date=${startDate!.toIso8601String()}&end_date=${endDate!.toIso8601String()}');
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
            reportsData.map((json) => SeniorReport.fromJson(json)).toList();
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
                                  _fetchSeniorReportWithDate(
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
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      detailsListTitleText('Senior'),
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
                  : const Center(
                      child: Text("No data available"),
                    ),
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

  Widget ListCard(SeniorReport report) {
    // String formattedDate =
    //     DateFormat('yyyy-MM-dd hh:mm a').format(transaction.date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: detailsListText(report.masterUsername),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.masterRealname),
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
                      builder: (context) => SeniorMasterReport(
                        name: report.masterUsername,
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
