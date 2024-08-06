import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
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
        transferIn: double.parse(json['IN'] ?? '0'),
        transferOut: double.parse(json['OUT'] ?? '0'),
        Bet: double.parse(json['Bet'] ?? '0'),
        Win: double.parse(json['Win'] ?? '0'),
        commissionAmount: double.parse(json['commission'] ?? '0'),
        balance: double.parse(json['balance'] ?? '0'),
        date: json['created_at'] ?? '',
      );
    } catch (e) {
      print('Error parsing Transaction from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}

class SSSeniorTransactionsTab extends StatefulWidget {
  final int userId;

  const SSSeniorTransactionsTab({super.key, required this.userId});

  @override
  State<SSSeniorTransactionsTab> createState() =>
      _SSSeniorTransactionsTabState();
}

class _SSSeniorTransactionsTabState extends State<SSSeniorTransactionsTab> {
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
    if (_token != null) {
      _fetchTransaction(widget.userId);
    }
  }

  Future<void> _fetchTransaction(int userId) async {
    var url = Uri.parse('${Config.apiUrl}/getTransaction/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
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

  void _filterTransactions() {
    if (startDate != null && endDate != null) {
      setState(() {
        filteredTransactions = transactions.where((transaction) {
          DateTime transactionDate = DateTime.parse(transaction.date);
          return transactionDate.isAfter(startDate!) &&
              transactionDate.isBefore(endDate!.add(const Duration(days: 1)));
        }).toList();
      });
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
                                    _filterTransactions();
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
                child: listTitleText('Date.'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Transfer In'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Transfer Out'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Bet'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Win'),
              ),
              Expanded(
                flex: 4,
                child: listTitleText('Commission'),
              ),
              Expanded(
                flex: 6,
                child: listTitleText('Balance'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Action'),
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
          child: listText(transaction.date),
        ),
        Expanded(
          flex: 5,
          child: listText(transaction.transferIn.toString()),
        ),
        Expanded(
          flex: 5,
          child: listText(transaction.transferOut.toString()),
        ),
        Expanded(
          flex: 5,
          child: listText(transaction.Bet.toString()),
        ),
        Expanded(
          flex: 5,
          child: listText(transaction.Win.toString()),
        ),
        Expanded(
          flex: 4,
          child: listText(transaction.commissionAmount.toString()),
        ),
        Expanded(
          flex: 6,
          child: listText(transaction.balance.toString()),
        ),
        Expanded(
          flex: 3,
          child: listText('Action'),
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

  Widget listTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget listText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }
}
