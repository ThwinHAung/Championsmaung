import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details_transcations_actionpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Transaction {
  final double transferIn;
  final double transferOut;
  final double Bet;
  final double Win;
  final double commissionAmount;
  final double balance;
  final String date;

  Transaction({
    required this.transferIn,
    required this.transferOut,
    required this.Bet,
    required this.Win,
    required this.commissionAmount,
    required this.balance,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    try {
      return Transaction(
        transferIn:
            json['IN'] != null ? double.parse(json['IN'].toString()) : 0,
        transferOut:
            json['OUT'] != null ? double.parse(json['OUT'].toString()) : 0,
        Bet: json['Bet'] != null ? double.parse(json['Bet'].toString()) : 0,
        Win: json['Win'] != null ? double.parse(json['Win'].toString()) : 0,
        commissionAmount: json['commission'] != null
            ? double.parse(json['commission'].toString())
            : 0,
        balance: json['balance'] != null
            ? double.parse(json['balance'].toString())
            : 0,
        date: json['date'] ??
            '', // Make sure this matches the date field returned by the backend
      );
    } catch (e) {
      print('Error parsing Transaction from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}

class SSSeniorTransactionsTab extends StatefulWidget {
  static const String id = 'sssenior_transition_tab';
  final int userId;

  const SSSeniorTransactionsTab({super.key, required this.userId});

  @override
  State<SSSeniorTransactionsTab> createState() =>
      _SSSeniorTransactionsTabState();
}

class _SSSeniorTransactionsTabState extends State<SSSeniorTransactionsTab>
    with WidgetsBindingObserver {
  DateTime? startDate;
  DateTime? endDate;
  String? _token;
  final storage = const FlutterSecureStorage();
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

  // void _filterTransactions() {
  //   if (startDate != null && endDate != null) {
  //     setState(() {
  //       filteredTransactions = transactions.where((transaction) {
  //         DateTime transactionDate = DateTime.parse(transaction.date);
  //         return transactionDate.isAfter(startDate!) &&
  //             transactionDate.isBefore(endDate!.add(const Duration(days: 1)));
  //       }).toList();
  //     });
  //   }
  // }

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
                borderRadius: BorderRadius.circular(10)),
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
                                    _fetchTransaction(
                                        widget.userId, startDate!, endDate!);
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: detailsListTitleText('Date.'),
              ),
              Expanded(
                flex: 5,
                child: detailsListTitleText('Transfer In'),
              ),
              Expanded(
                flex: 5,
                child: detailsListTitleText('Transfer Out'),
              ),
              Expanded(
                flex: 5,
                child: detailsListTitleText('Bet'),
              ),
              Expanded(
                flex: 5,
                child: detailsListTitleText('Win'),
              ),
              Expanded(
                flex: 4,
                child: detailsListTitleText('Commission'),
              ),
              Expanded(
                flex: 6,
                child: detailsListTitleText('Balance'),
              ),
              Expanded(
                flex: 3,
                child: detailsListTitleText('Action'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                return ListCard(filteredTransactions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard(Transaction transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: detailsListText(transaction.date),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(transaction.transferIn.toString()),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(transaction.transferOut.toString()),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(transaction.Bet.toString()),
        ),
        Expanded(
          flex: 5,
          child: detailsListText(transaction.Win.toString()),
        ),
        Expanded(
          flex: 4,
          child: detailsListText(transaction.commissionAmount.toString()),
        ),
        Expanded(
          flex: 6,
          child: detailsListText(transaction.balance.toString()),
        ),
        Expanded(
          flex: 3,
          child: IconButton(
            onPressed: () {
              // userId: userId
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TranscationsActionPage(
                          userId: widget.userId,
                          date: transaction.date,
                        )),
              );
            },
            icon: const Icon(
              Icons.remove_red_eye_outlined,
            ),
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
