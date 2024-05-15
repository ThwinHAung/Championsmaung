import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page_for_route.dart';
import 'package:flutter/material.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/body_betting.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/match_results.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/maung_betting.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/more.dart';
import 'package:champion_maung/constants.dart';
import 'package:http/http.dart' as http;

class UserHomeScreen extends StatefulWidget {
  static String id = 'userHome_screen';
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  var list = ['BODY', 'MAUNG', 'MATCHES RESULTS', 'BETTING HISTORY', 'MORE'];
  var listRoutes = [
    BodyBetting.id,
    MaungBetting.id,
    MatchResults.id,
    BettingHistory.id,
    More.id,
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'CHAMPION MAUNG',
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                width: double.infinity,
                height: height * .23,
                decoration: BoxDecoration(
                  color: kOnPrimaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Text(
                        'YOUR BALANCE',
                        style: TextStyle(
                          color: kGrey,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        '000,000' '  MMK',
                        style: TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height / 100,
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'ဘယ်လိုလောင်းလောင်း PLUS ပေါင်း',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: ListTile(
                                title: Text(
                                  list[index],
                                  style: const TextStyle(
                                    color: kBlue,
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.arrow_right,
                                  color: konPrimary,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, listRoutes[index]);
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView.builder(
            itemCount: userDrawerList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  userDrawerList[index],
                  style: const TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, userDrawerRoutes[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  var userDrawerList = [
    'Rules and Regulations',
    'Change Langugae',
    'Log Out',
  ];

  var userDrawerRoutes = [
    RulesPageForRoute.id,
    '',
    'logout',
  ];
}
