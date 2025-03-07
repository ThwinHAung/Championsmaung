import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
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

class _SSSeniorDashboardState extends State<SSSeniorDashboard>
    with WidgetsBindingObserver {
  final storage = const FlutterSecureStorage();
  String? _token;
  int? _memberCount;
  String? _role = '';
  double? _balance, _downLineBalance, _outstandingBalance;
  String firstItem = 'Members'; // Default value

  var list = [
    'Loading...',
    'Balance',
    'Downline Balance',
    'Outstanding Balance',
  ];

  final showValues = [
    000000,
    000000,
    000000,
    000000,
  ];
  final List showIcons = [
    const Icon(Icons.people_alt_outlined, color: kBlue),
    const Text('MMK',
        style: TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
    const Icon(Icons.stacked_bar_chart_outlined, color: kBlue),
    const Icon(Icons.stacked_line_chart_outlined, color: kBlue),
  ];

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    _role = await storage.read(key: 'user_role');

    if (_token != null) {
      setState(() {
        list[0] = _getFirstItem();
      });
      _getBalance();
      _getMemberCount();
      _getDownLineBalance();
      _getOutStandingBalance();
    }
  }

  String _getFirstItem() {
    return _role == 'SSSenior'
        ? 'SSenior'
        : _role == 'SSenior'
            ? 'Senior'
            : _role == 'Senior'
                ? 'Master'
                : _role == 'Master'
                    ? 'Agent'
                    : 'Members';
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
    }
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
            padding: const EdgeInsets.all(10),
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
                      margin: const EdgeInsets.only(bottom: 10),
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
                                        fontSize: 30,
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
    );
  }
}
