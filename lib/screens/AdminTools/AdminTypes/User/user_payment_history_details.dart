import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class UserPaymentHistoryDetails extends StatefulWidget {
  const UserPaymentHistoryDetails({super.key});

  static const String id = 'user_payment_history_details';

  @override
  State<UserPaymentHistoryDetails> createState() => _UserPaymentHistoryDetailsState();
}

class _UserPaymentHistoryDetailsState extends State<UserPaymentHistoryDetails> {
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
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: kBlue,
                boxShadow: [
                  BoxShadow(
                    color: kBlack,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Expanded(child: Text(
                  'Date', // Add your desired content here
                  style: TextStyle(
                    fontSize: 16.0,
                    color: kWhite,
                  ),
                ),),
                Expanded(child: Text(
                  'Info', // Add your desired content here
                  style: TextStyle(
                    fontSize: 16.0,
                    color: kWhite,
                  ),
                ),),
                Expanded(child: Text(
                  'Amount', // Add your desired content here
                  style: TextStyle(
                    fontSize: 16.0,
                    color: kWhite,
                  ),
                ),),
                ],
                ),
              ),
            ),
            SizedBox(height: 10.0), // Spacer between top and ListView
        
            // Middle ListView
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example item count for the list
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            
                        Expanded(child: labelText('22-2-2024')),
                        Expanded(child: labelText('From Godfater')),
                        Expanded(child: labelText('10000')),

                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        
            SizedBox(height: 10.0), // Spacer between ListView and bottom container
        
            // Bottom Container
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
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
                  Text(
                    'Total =      ', // Add your desired content here
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '000,000', // Add your desired content here
                    style: TextStyle(
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
