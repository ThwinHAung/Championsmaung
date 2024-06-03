import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting/body_betting.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/match_results.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting/maung_betting.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/more.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page_for_route.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_change_password.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserHomeScreen extends StatefulWidget {
  static String id = 'userHome_screen';
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? _username = '';
  double? _balance = 0;
  var list = ['BODY', 'MAUNG', 'MATCHES RESULTS', 'BETTING HISTORY', 'MORE'];
  var listRoutes = [
    BodyBetting.id,
    MaungBetting.id,
    MatchResults.id,
    BettingHistory.id,
    More.id,
  ];
  @override
  void initState() {
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    _username = await storage.read(key: 'user_name');
    if (_token != null) {
      _getBalance();
    }
  }

  Future<void> _getBalance() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/get_balance');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _balance = double.parse(data['balance'].toString());
      });
    }
  }

  Future<void> _logout() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/logout');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'role');
      await storage.delete(key: 'username');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      print(response.body);
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
                decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25.0),
                      Text(
                        'Username : $_username',
                        style: TextStyle(
                          color: kWhite.withOpacity(.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'YOUR BALANCE',
                            style: TextStyle(
                              color: kOnPrimaryContainer,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          IconButton(
                            onPressed: () {
                              _getBalance();
                            },
                            icon: const Icon(
                              Icons.refresh_outlined,
                              color: kOnPrimaryContainer,
                            ),
                            style: IconButton.styleFrom(
                              iconSize: 20,
                            ),
                          )
                        ],
                      ),
                      Text(
                        '$_balance MMK',
                        style: const TextStyle(
                          color: kOnPrimaryContainer,
                          fontWeight: FontWeight.w500,
                          fontSize: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'ဘယ်လိုလောင်းလောင်း PLUS ပေါင်း',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
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
          child: _userDrawerListView(),
        ),
      ),
    );
  }

  Widget _userDrawerListView() {
    return ListView.builder(
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
            if (userDrawerRoutes[index] == 'logout') {
              _logout();
            } else {
              Navigator.pushNamed(context, userDrawerRoutes[index]);
            }
          },
        );
      },
    );
  }

  var userDrawerList = [
    'Rules and Regulations',
    'Change Langugae',
    'Change Password',
    'Log Out',
  ];

  var userDrawerRoutes = [
    RulesPageForRoute.id,
    '',
    UserChangePassword.id,
    'logout',
  ];
}
