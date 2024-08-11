import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/change_password_self.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class AgentAdminScreen extends StatefulWidget {
  static const String id = 'agent_admin_screen';
  const AgentAdminScreen({super.key});

  @override
  State<AgentAdminScreen> createState() => _AgentAdminScreenState();
}

class _AgentAdminScreenState extends State<AgentAdminScreen>
    with WidgetsBindingObserver {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? _role;
  double? _balance;
  double? _outstandingBalance;
  double? _downLineBalance;
  int? _memberCount;
  var list = [
    'Members',
    'Balance',
    'Downtime Balance',
    'Outstanding Balance',
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
    super.initState();
    _role = 'Loading...';
    _getToken();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getToken();
    }
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
      _getBalance();
      _getMemberCount();
      _getDownLineBalance();
      _getOutStandingBalance();
    }
  }

  Future<void> _getBalance() async {
    var url = Uri.parse('${Config.apiUrl}/get_balance');
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

  Future<void> _getMemberCount() async {
    var url = Uri.parse('${Config.apiUrl}/getmemberCount');
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
        _memberCount = int.parse(data['userCount'].toString());
      });
    } else {
      print(response.body);
    }
  }

  Future<void> _getDownLineBalance() async {
    var url = Uri.parse('${Config.apiUrl}/getdownlineBalance');
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
        _downLineBalance = double.parse(data['downlineBalance'].toString());
      });
    } else {
      print(response.body);
    }
  }

  Future<void> _getOutStandingBalance() async {
    var url = Uri.parse('${Config.apiUrl}/getoutstandingBalance');
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
        _outstandingBalance =
            double.parse(data['outstandingBalance'].toString());
      });
    } else {
      print(response.body);
    }
  }

  Future<void> _logout() async {
    var url = Uri.parse('${Config.apiUrl}/logout');
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
      Navigator.pushReplacementNamed(context, LoginScreen.id);
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
              String displayValue = '';
              if (index == 0) {
                displayValue = _memberCount?.toString() ?? '0';
              } else if (index == 1) {
                displayValue = _balance?.toStringAsFixed(2) ?? '0';
              } else if (index == 2) {
                displayValue = _downLineBalance?.toStringAsFixed(2) ?? '0';
              } else if (index == 3) {
                displayValue = _outstandingBalance?.toStringAsFixed(2) ?? '0';
              }

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index],
                                      style: kTextFieldActiveStyle,
                                    ),
                                    Text(
                                      displayValue,
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
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: kOnPrimaryContainer,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: 30.0),
            ListTile(
              title: drawerListMenuText('Dashboard'),
              onTap: () {
                // Handle menu 1 tap
              },
            ),
            ExpansionTile(
              title: drawerListMenuText('Members Management'),
              children: <Widget>[
                ListTile(
                  title: drawerListSubMenuText('Create Member'),
                  onTap: () {
                    Navigator.pushNamed(context, AgentMembers.id);
                  },
                ),
                ListTile(
                  title: drawerListSubMenuText('Members List'),
                  onTap: () {
                    Navigator.pushNamed(context, SSSeniorShowMembersList.id);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: drawerListMenuText('Report'),
              children: <Widget>[
                ListTile(
                  title: drawerListSubMenuText('Daily'),
                  onTap: () {
                    // Handle submenu 2.1 tap
                  },
                ),
                ListTile(
                  title: drawerListSubMenuText('Master'),
                  onTap: () {
                    // Handle submenu 2.2 tap
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: drawerListMenuText('Account'),
              children: <Widget>[
                ListTile(
                  title: drawerListSubMenuText('Change Password'),
                  onTap: () {
                    Navigator.pushNamed(context, ChangePasswordSelf.id);
                  },
                ),
              ],
            ),
            ListTile(
              title: drawerListMenuText('Log Out'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
