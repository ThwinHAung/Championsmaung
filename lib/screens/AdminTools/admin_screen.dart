import 'package:champion_maung/screens/AdminTools/AdminToolPages/activity_log.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/create_user.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/user_accounts.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/user_list.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/user_report.dart';
import 'package:flutter/material.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdminScreen extends StatefulWidget {
  static String id = 'admin_screen';
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  var list = [
    'Members',
    'Balance',
    'Downtime Balance',
    'Outstanding Balance',
  ];
  var listRoutes = [
    CreateUser.id,
    UserList.id,
    UserReport.id,
    UserDeposit.id,
    UserAccounts.id,
  ];
  var drawerList = [
    'Transition Activity Log',
    'Members',
    'Report',
    'Deposit / Withdraw',
    'Account',
    'Log Out',
  ];
  var drawerRoutes = [
    ActivityLogScreen.id,
  ];
  var showValues = [
    000000,
    000000,
    000000,
    000000,
  ];
  List<IconData> showIcons = [
    Icons.people_alt_outlined,
    Icons.attach_money_outlined,
    Icons.stacked_bar_chart_outlined,
    Icons.stacked_line_chart_outlined,
  ];
  List<IconData> drawerIcons = [
    Icons.history,
  ];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'CHAMPION MAUNG (Admin)',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        color: kPrimary,
        child: AnimationLimiter(
          child: ListView.builder(
              padding: EdgeInsets.all(w / 50),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 2500),
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(bottom: w / 30),
                        height: h / 5.5,
                        decoration: BoxDecoration(
                            color: kOnPrimaryContainer,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 10,
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list[index],
                                        style: kTextFieldActiveStyle,
                                      ),
                                      Text(
                                        showValues[index].toString(),
                                        style: const TextStyle(
                                          fontSize: 35,
                                          color: kBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Icon(
                                    showIcons[index],
                                    color: kBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView.builder(
            itemCount: drawerList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  drawerList[index],
                  style: const TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  // Handle onTap for each item here
                  Navigator.pop(context); // Close the drawer
                  // You can perform additional actions based on the tapped item
                  print('Tapped on ${drawerList[index]}');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
