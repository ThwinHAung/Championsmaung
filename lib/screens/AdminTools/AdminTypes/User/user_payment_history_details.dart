import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserTransitionDetails {
  final String description;
  final String type;
  final double amount;
  final String date;

  UserTransitionDetails({
    required this.description,
    required this.type,
    required this.amount,
    required this.date,
  });
  factory UserTransitionDetails.fromJson(Map<String, dynamic> json) {
    return UserTransitionDetails(
      description: json['description'],
      type: json['type'],
      amount: double.parse(json['amount'] ?? '0.0'),
      date: json['created_at'] as String,
    );
  }
}

class UserPaymentHistoryDetails extends StatefulWidget {
  const UserPaymentHistoryDetails({super.key});

  static const String id = 'user_payment_history_details';

  @override
  State<UserPaymentHistoryDetails> createState() =>
      _UserPaymentHistoryDetailsState();
}

class _UserPaymentHistoryDetailsState extends State<UserPaymentHistoryDetails> {
  String? _token;
  final storage = const FlutterSecureStorage();
  List<UserTransitionDetails> _transitions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the 'date' argument passed from the previous page
      final date = ModalRoute.of(context)?.settings.arguments as String?;
      if (date != null) {
        _getTokenAndFetchDetails(date);
      }
    });
  }

  Future<void> _getTokenAndFetchDetails(String date) async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      fetchUserTransitionDetail(date);
    }
  }

  Future<void> fetchUserTransitionDetail(String date) async {
    var url = Uri.parse('${Config.apiUrl}/getUserTrasitionDetail?date=$date');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body) as List<dynamic>;
      setState(() {
        _transitions = jsonResponse
            .map((json) =>
                UserTransitionDetails.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    } else {
      print(response.body);
      print("Failed to fetch data: ${response.statusCode}");
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
          'PAYMENT HISTORY DETAILS',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: kPrimary,
        ),
        child: Column(
          children: [
            // Top Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: kBlue,
                boxShadow: [
                  BoxShadow(
                    color: kBlack,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date', // Add your desired content here
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kWhite,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Info', // Add your desired content here
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kWhite,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Amount', // Add your desired content here
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0), // Spacer between top and ListView

            // Middle ListView
            Expanded(
              child: ListView.builder(
                itemCount: _transitions.length,
                itemBuilder: (context, index) {
                  UserTransitionDetails transition = _transitions[index];
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: labelText(transition.date)),
                            Expanded(child: labelText(transition.description)),
                            Expanded(
                              child: Text(
                                transition.amount.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: transition.type == 'IN'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
                height: 10.0), // Spacer between ListView and bottom container

            // Bottom Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: kGrey,
                boxShadow: [
                  BoxShadow(
                    color: kBlack,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total =      ', // Add your desired content here
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _transitions
                        .fold(0.0, (sum, item) => sum + item.amount)
                        .toStringAsFixed(2), // Add your desired content here
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: kBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
