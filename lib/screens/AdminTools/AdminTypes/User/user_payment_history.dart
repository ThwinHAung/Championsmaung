import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_home_screen.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_payment_history_details.dart';
import 'package:flutter/material.dart';

class UserPaymentHistory extends StatefulWidget {
  const UserPaymentHistory({super.key});

  static const String id = 'user_payment_history';

  @override
  State<UserPaymentHistory> createState() => _UserPaymentHistoryState();
}

class _UserPaymentHistoryState extends State<UserPaymentHistory> {
  TextEditingController _dateRangeFromController = TextEditingController();
  TextEditingController _dateRangetoController = TextEditingController();
  String _selectedSortOption = 'Date'; // Default selected option

  void _showCustomDateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kPrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date Range.'),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _dateRangeFromController,
              style: kTextFieldActiveStyle,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'From',
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _dateRangetoController,
              style: kTextFieldActiveStyle,
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'To',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: materialButton(kError, 'Cancel', () {
                  Navigator.pop(context);
                }),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: materialButton(kBlue, 'Submit', () {
                  // Implement submit functionality
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(String widgetId) {
    Navigator.pushNamed(context, UserPaymentHistoryDetails.id, arguments: widgetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'PAYMENT HISTORY',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.sort, color: konPrimary),
              onSelected: (String value) {
                setState(() {
                  _selectedSortOption = value;
                });
                if (value == '3') {
                  _showCustomDateDialog(); // Show dialog when "Custom" is selected
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: '1',
                  child: Text(' 5 day '),
                ),
                const PopupMenuItem<String>(
                  value: '2',
                  child: Text(' 3 day  '),
                ),
                const PopupMenuItem<String>(
                  value: '3',
                  child: Text(' Custom  '),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: kPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: labelText('22-2-2024    အဖွင့်လက်ကျန်'),
                  ),
                  labelText('0'),
                ],
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Display 5 items in the list
                  itemBuilder: (context, index) {
                    // Generating unique widget ID for each container
                    String widgetId = 'widget_id_${index}';
                    return GestureDetector(
                      onTap: () => _navigateToDetails(widgetId), // Pass widget-specific ID
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: kOnPrimaryContainer,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: kBlack,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kBlue,
                                  ),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                    child: Text(
                                      '22-2-2024',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('သွင်းငွေ'),
                                labelText('0'),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('ပြန်ရငွေ'),
                                labelText('0'),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('လောင်းငွေ'),
                                labelText('0'),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('ထုတ်ငွေ'),
                                labelText('0'),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                labelText('လက်ကျန်'),
                                labelText('0'),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              '22-2-2024' + 'နေ့လယ် ၁၂ နာရီမှ' + '23-2-2024' + 'နေ့လယ် ၁၂ နာရီအထိ',
                              style: TextStyle(color: kBlue, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

