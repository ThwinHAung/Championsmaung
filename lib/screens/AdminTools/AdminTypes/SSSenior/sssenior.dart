import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_add_league_name.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_inputs.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_match_history.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_match_view.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class SSSeniorAdminScreen extends StatefulWidget {
  static String id = 'sssenior_admin_screen';
  const SSSeniorAdminScreen({super.key});
  @override
  State<SSSeniorAdminScreen> createState() => _SSSeniorAdminScreenState();
}

class _SSSeniorAdminScreenState extends State<SSSeniorAdminScreen> {
  final storage = const FlutterSecureStorage();
  String? _token;
  var list = [
    'Members',
    'Balance',
    'Downline Balance',
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
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data or perform necessary actions
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      // _getMemberCount();
      // _getDownLineBalance();
      // _getOutStandingBalance();
    }
  }

  Future<void> _getMemberCount() async {
    var url = Uri.parse('${Config.apiUrl}/logout');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> _getDownLineBalance() async {
    var url = Uri.parse('${Config.apiUrl}/logout');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> _getOutStandingBalance() async {
    var url = Uri.parse('${Config.apiUrl}/logout');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
    } else {}
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
      await storage.delete(key: 'username');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {}
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
        title: const Text(
          'CHAMPION MAUNG (SSSenior)',
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
              padding: const EdgeInsets.all(10.0),
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
                    Navigator.pushNamed(context, SSSeniorMembers.id);
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
              title: drawerListMenuText('Matches Management'),
              children: <Widget>[
                ListTile(
                  title: drawerListSubMenuText('Add League Name'),
                  onTap: () {
                    Navigator.pushNamed(context, LeagueScreen.id);
                  },
                ),
                ListTile(
                  title: drawerListSubMenuText('Add Matches'),
                  onTap: () {
                    Navigator.pushNamed(context, SSSeniorInputsPage.id);
                  },
                ),
                ListTile(
                  title: drawerListSubMenuText('View Pending Matches'),
                  onTap: () {
                    Navigator.pushNamed(context, SSSeniorMatchView.id);
                  },
                ),
                ListTile(
                  title: drawerListSubMenuText('View Matches History'),
                  onTap: () {
                    Navigator.pushNamed(context, SSSeniorMatchHistory.id);
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

/* Padding(
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
        ), */
