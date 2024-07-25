import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Master/master_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Master/master_show_members_list.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/account.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/activity_log.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_show_members_list.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class MasterAdminScreen extends StatefulWidget {
  static String id = 'master_admin_screen';
  const MasterAdminScreen({super.key});

  @override
  State<MasterAdminScreen> createState() => _MasterAdminScreenState();
}

class _MasterAdminScreenState extends State<MasterAdminScreen> {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? _role;
  double? _balance;
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
    MasterMembers.id,
    MasterShowMembersList.id,
    Report.id,
    Deposit.id,
    AccountSettings.id,
    'logout'
  ];
  var showValues = [
    000000,
    000000,
    000000,
    000000,
  ];
  List showIcons = [
    const Icon(Icons.people_alt_outlined, color: kBlue),
    const Text('MMK',
        style: TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
    const Icon(Icons.stacked_bar_chart_outlined, color: kBlue),
    const Icon(Icons.stacked_line_chart_outlined, color: kBlue),
  ];
  @override
  void initState() {
    _role = 'Loading...';
    _getToken();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data or perform necessary actions
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    final String? role = await storage.read(key: 'user_role');

    if (role != null) {
      setState(() {
        _role = role;
      });
    }
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: Text(
          'CHAMPION MAUNG ($_role)',
          style: const TextStyle(
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
                                        index == 1 && _balance != null
                                            ? _balance!.toStringAsFixed(2)
                                            : '0', // Display 'Loading...' while balance is being fetched
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
                                  alignment: Alignment.center,
                                  child: showIcons[index],
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
                  if (drawerRoutes[index] == 'logout') {
                    _logout();
                  } else {
                    Navigator.pushNamed(context, drawerRoutes[index]);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
