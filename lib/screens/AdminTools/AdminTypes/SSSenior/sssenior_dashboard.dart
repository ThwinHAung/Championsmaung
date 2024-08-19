import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class SSSeniorDashboard extends StatefulWidget {
  static const String id = 'sssenior_dahsboard';
  const SSSeniorDashboard({super.key});
  @override
  State<SSSeniorDashboard> createState() => _SSSeniorDashboardState();
}

class _SSSeniorDashboardState extends State<SSSeniorDashboard> {
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
    // Refresh data or perform necessary actions
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    // if (_token == null) {
    //   _redirectToLogin();
    // }
  }

  // void _redirectToLogin() {
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     LoginScreen.id,
  //     (Route<dynamic> route) => false,
  //   );
  // }

  // _getMemberCount();
  // _getDownLineBalance();
  // _getOutStandingBalance();

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

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimary,
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
                        margin: EdgeInsets.only(bottom: 20),
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
    );
  }
}
