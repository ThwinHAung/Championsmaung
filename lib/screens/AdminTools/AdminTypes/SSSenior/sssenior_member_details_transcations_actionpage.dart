import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Transaction {
  final DateTime date;
  final String description;
  final String type;
  final double amount;
  final double balance;

  Transaction({
    required this.date,
    required this.description,
    required this.type,
    required this.amount,
    required this.balance,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: DateTime.parse(json['date']),
      description: json['description'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      balance: double.parse(json['balance'].toString()),
    );
  }
}

class TranscationsActionPage extends StatefulWidget {
  static String id = 'transcations_action_page';
  final int userId;
  final String date;

  const TranscationsActionPage(
      {super.key, required this.userId, required this.date});

  @override
  State<TranscationsActionPage> createState() => _TranscationsActionPageState();
}

class _TranscationsActionPageState extends State<TranscationsActionPage> {
  String? _token;
  final storage = const FlutterSecureStorage();
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchTransactionsForDate(widget.userId, widget.date);
    }
  }

  Future<void> _fetchTransactionsForDate(int userId, String date) async {
    var url =
        Uri.parse('${Config.apiUrl}/getTransactionsForDate/$userId/$date');
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
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
      ),
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
        children: <Widget>[
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: detailsListTitleText('Date'),
              ),
              Expanded(
                flex: 3,
                child: detailsListTitleText('Description'),
              ),
              Expanded(
                flex: 3,
                child: detailsListTitleText('Transaction Type'),
              ),
              Expanded(
                flex: 3,
                child: detailsListTitleText('Amount'),
              ),
              Expanded(
                flex: 3,
                child: detailsListTitleText('Balance'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0), // Add vertical padding
                  child: ListCard(transactions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard(Transaction transaction) {
    String formattedDate =
        DateFormat('yyyy-MM-dd hh:mm a').format(transaction.date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: detailsListText(formattedDate),
        ),
        Expanded(
          flex: 3,
          child: detailsListText(transaction.description),
        ),
        Expanded(
          flex: 3,
          child: detailsListText(transaction.type),
        ),
        Expanded(
          flex: 3,
          child: detailsListText(transaction.amount.toString()),
        ),
        Expanded(
          flex: 3,
          child: detailsListText(transaction.balance.toString()),
        ),
      ],
    );
  }
}
