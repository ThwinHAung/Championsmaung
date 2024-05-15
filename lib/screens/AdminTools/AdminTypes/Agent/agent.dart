import 'package:champion_maung/screens/AdminTools/AdminToolPages/activity_log.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/report.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/account.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_show_members_list.dart';
import 'package:flutter/material.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AgentAdminScreen extends StatefulWidget {
  static String id = 'agent_admin_screen';
  const AgentAdminScreen({super.key});

  @override
  State<AgentAdminScreen> createState() => _AgentAdminScreenState();
}

class _AgentAdminScreenState extends State<AgentAdminScreen> {
  var list = [
    'Members',
    'Balance',
    'Downtime Balance',
    'Outstanding Balance',
  ];
  var drawerList = [
    'Transition Activity Log',
    'Members',
    'Members List',
    'Report',
    'Deposit / Withdraw',
    'Account',
    'Log Out',
  ];
  var drawerRoutes = [
    ActivityLogScreen.id,
    AgentMembers.id,
    AgentShowMembersList.id,
    Report.id,
    Deposit.id,
    AccountSettings.id,
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
          'CHAMPION MAUNG (Agent)',
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
                        decoration: const BoxDecoration(
                          color: kOnPrimaryContainer,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
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
                  Navigator.pushNamed(context, drawerRoutes[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
