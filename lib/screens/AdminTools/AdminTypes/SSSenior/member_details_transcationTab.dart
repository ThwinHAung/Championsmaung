import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsTab extends StatefulWidget {
  final int userId;

  const TransactionsTab({Key? key, required this.userId}) : super(key: key);

  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  DateTime? startDate;
  DateTime? endDate;

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
                          SizedBox(width: 5.0),
                          Expanded(
                              flex: 3,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
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
                flex: 3,
                child: Container(),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Commission Amount'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Balance'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Action'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: listText('1.1.2024'),
        ),
        Expanded(
          flex: 5,
          child: listText('100000'),
        ),
        Expanded(
          flex: 5,
          child: listText('50000'),
        ),
        Expanded(
          flex: 3,
          child: Container(),
        ),
        Expanded(
          flex: 5,
          child: listText('15000'),
        ),
        Expanded(
          flex: 5,
          child: listText('500000'),
        ),
        Expanded(
          flex: 5,
          child: listText('Action'),
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(Duration(days: 30)),
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
