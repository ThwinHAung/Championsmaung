import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details_transcations_actionpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class UserReportDetails extends StatefulWidget {
  const UserReportDetails({
    super.key,
  });

  static const String id = 'user_report_details';

  @override
  State<UserReportDetails> createState() => _UserReportDetailsState();
}

class _UserReportDetailsState extends State<UserReportDetails>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  DateTime? endDate;
  List<Transaction> filteredTransactions = [];
  DateTime? startDate;
  final storage = const FlutterSecureStorage();
  List<Transaction> transactions = [];
  int? userId;

  String? _token;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Widget view() {
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
                  child: detailsListTitleText('Home'),
                ),
                Expanded(
                  flex: 4,
                  child: detailsListTitleText('Goal'),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: detailsListTitleText('Away')),
                ),
                Expanded(flex: 2,
                child: Container()),
                Expanded(
                  flex: 4,
                  child: detailsListTitleText('Goal Price'),
                ),
                
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: detailsListTitleText('Bet Choice')),
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
                  child: detailsListText('Home'),
                ),
                Expanded(
                  flex: 4,
                  child: detailsListText('Goal'),
                ),
                Expanded(
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: detailsListText('Away')),
                ),
                Expanded(flex: 2,
                child: Container()),
                Expanded(
                  flex: 4,
                  child: detailsListText('Goal Price'),
                ),
                
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: detailsListText('Bet Choice')),
                ),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 5),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              listText('Bet ID:'),
                              listText('Time:'),
                            ],
                          ),
                        ),Expanded(
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              listText('Master Bet:'),
                              listText('User Bet:'),
                            ],
                          ),
                        ),Expanded(
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              listText('Master %:'),
                              listText('User %:'),
                            ],
                          ),
                        ),Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              listText('Master Win:'),
                              listText('User Win:'),
                            ],
                          ),
                        ),Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              listText('Status:'),
                              ],
                          ),
                        ),
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
}
