import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SSSeniorReport {
  final int SSeniorId;
  final String username;
  final String realname;
  final double turnover;
  final double validAmount;
  final double adjustedWinLoss;
  final double ssenior_com;

  SSSeniorReport({
    required this.SSeniorId,
    required this.username,
    required this.realname,
    required this.turnover,
    required this.validAmount,
    required this.adjustedWinLoss,
    required this.ssenior_com,
  });

  factory SSSeniorReport.fromJson(Map<String, dynamic> json) {
    return SSSeniorReport(
        SSeniorId: json['ssenior_id'],
        username: json['ssenior_username'],
        realname: json['ssenior_realname'],
        turnover: double.parse(json['total_turnover']),
        validAmount: double.parse(json['total_valid_amount']),
        adjustedWinLoss: double.parse(json['total_win_loss']),
        ssenior_com: double.parse(json['total_ssenior_commission']));
  }
}

class SSSeniorDailyReport extends StatefulWidget {
  static const String id = 'sssenior_daily_report';

  const SSSeniorDailyReport({
    super.key,
  });

  @override
  State<SSSeniorDailyReport> createState() => _SSSeniorDailyReportState();
}

class _SSSeniorDailyReportState extends State<SSSeniorDailyReport>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int? userId;
  final storage = const FlutterSecureStorage();
  String? _token;

  DateTime? startDate;
  DateTime? endDate;
  List<SSSeniorReport> _reports = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  Future<void> _fetchReport(DateTime? start, DateTime? end) async {
    if (start == null || end == null || _token == null) {
      return; // Ensure the dates and token are set before making the request
    }

    var url = Uri.parse(
        '${Config.apiUrl}/ssseniorReport?start_date=${start.toIso8601String()}&end_date=${end.toIso8601String()}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        _reports = jsonResponse
            .map((report) => SSSeniorReport.fromJson(report))
            .toList();
      });
    } else {
      // Handle error
      print('Failed to load reports');
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
                                  if (startDate != null && endDate != null) {
                                    _fetchReport(startDate, endDate);
                                  }
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: ListCard(_reports[index]),
                        );
                      },
                    )
                  : const Center(child: Text("No data available")),
            ),
          ],
        ),
      ),
    );
  }

  Widget ListCard(SSSeniorReport report) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: detailsListText(report.username),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.realname),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.turnover.toString()),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(report.validAmount.toString()),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: detailsListText(report.adjustedWinLoss.toString()),
                ),
                Expanded(
                  child: detailsListText(report.ssenior_com.toString()),
                ),
                Expanded(
                  child: detailsListText(
                    (report.adjustedWinLoss + report.ssenior_com).toString(),
                  ),
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
                // Navigator.pushNamed(context, SSeniorDailyReport.id);
              },
              icon: const Icon(
                Icons.remove_red_eye_outlined,
                size: 15,
              ),
            ),
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

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
    if (selectedRange != null) {
      setState(() {
        startDate = selectedRange.start;
        endDate = selectedRange.end;
      });
      _fetchReport(
          startDate, endDate); // Fetch the report with the new date range
    }
  }
}
