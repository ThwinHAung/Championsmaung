import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details_transcations_actionpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SSSeniorDailyReport extends StatefulWidget {
  static String id = 'sssenior_daily_report';

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
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  Future<void> _fetchTransaction(
      int userId, DateTime? start, DateTime? end) async {
    var url = Uri.parse(
        '${Config.apiUrl}/getTransaction/$userId?start_date=${startDate!.toIso8601String()}&end_date=${endDate!.toIso8601String()}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      setState(() {
        transactions = jsonResponse
            .map((transaction) => Transaction.fromJson(transaction))
            .toList();
        filteredTransactions = transactions;
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kPrimary,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: kOnPrimaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: view(),
          ),
        ),
      ),
    );
  }

  Widget view() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
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
                                    _fetchTransaction(1, startDate!, endDate!);
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
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: detailsListTitleText('Date.'),
              ),
              VerticalDivider(),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    detailsListTitleText('Company'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: detailsListTitleText('Bet'),
                        ),
                        Expanded(
                          child: detailsListTitleText('Commision'),
                        ),
                        Expanded(
                          child: detailsListTitleText('W/L'),
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
                    detailsListTitleText('Senior Master'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: detailsListTitleText('Bet'),
                        ),
                        Expanded(
                          child: detailsListTitleText('Commision'),
                        ),
                        Expanded(
                          child: detailsListTitleText('W/L'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalDivider(),
              Expanded(
                flex: 4,
                child: detailsListTitleText('Commission'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: ListCard(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard() {
    // String formattedDate =
    //     DateFormat('yyyy-MM-dd hh:mm a').format(transaction.date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: detailsListText('2.2.2024'),
        ),
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: detailsListText('500'),
                ),
                Expanded(
                  child: detailsListText('5'),
                ),
                Expanded(
                  child: detailsListText('W'),
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
                  child: detailsListText('500'),
                ),
                Expanded(
                  child: detailsListText('7'),
                ),
                Expanded(
                  child: detailsListText('L'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: detailsListText('100'),
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
