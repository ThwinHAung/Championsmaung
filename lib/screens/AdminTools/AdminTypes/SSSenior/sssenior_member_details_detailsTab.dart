import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserDetails {
  final String realname;
  final String username;
  final String phoneNumber;
  final String balance;
  final String maxSingleBet;
  final String maxMixBet;
  String status;

  UserDetails({
    required this.realname,
    required this.username,
    required this.phoneNumber,
    required this.balance,
    required this.maxSingleBet,
    required this.maxMixBet,
    required this.status,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        realname: json['realname'],
        username: json['username'],
        phoneNumber: json['phone_number'],
        balance: json['balance'].toString(),
        maxSingleBet: json['maxSingleBet'].toString(),
        maxMixBet: json['maxMixBet'].toString(),
        status: json['status']);
  }
}

class SingleCommissions {
  final int high;
  final int low;

  SingleCommissions({
    required this.high,
    required this.low,
  });

  factory SingleCommissions.fromJson(Map<String, dynamic> json) {
    return SingleCommissions(
      high: json['high'],
      low: json['low'],
    );
  }
}

class MixCommissions {
  final int m2;
  final int m3;
  final int m4;
  final int m5;
  final int m6;
  final int m7;
  final int m8;
  final int m9;
  final int m10;
  final int m11;

  MixCommissions({
    required this.m2,
    required this.m3,
    required this.m4,
    required this.m5,
    required this.m6,
    required this.m7,
    required this.m8,
    required this.m9,
    required this.m10,
    required this.m11,
  });

  factory MixCommissions.fromJson(Map<String, dynamic> json) {
    return MixCommissions(
      m2: json['m2'],
      m3: json['m3'],
      m4: json['m4'],
      m5: json['m5'],
      m6: json['m6'],
      m7: json['m7'],
      m8: json['m8'],
      m9: json['m9'],
      m10: json['m10'],
      m11: json['m11'],
    );
  }
}

class SSSeniorDetailsTab extends StatefulWidget {
  final int userId;
  const SSSeniorDetailsTab({super.key, required this.userId});

  @override
  State<SSSeniorDetailsTab> createState() => _SSSeniorDetailsTabState();
}

class _SSSeniorDetailsTabState extends State<SSSeniorDetailsTab> {
  String? _token;
  final storage = const FlutterSecureStorage();
  UserDetails? _userDetails;
  SingleCommissions? _singleCommissions;
  MixCommissions? _mixCommissions;

  @override
  void initState() {
    super.initState();
    _getToken();
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

  void clearForms() {
    _newPasswordController.clear();
    _confirmNewPasswordController.clear();
    _amountController.clear();
    _nameEditController.clear();
    _phoneNumberEditController.clear();
    _sharePercentageEditController.clear();
    _mixBetLimitationEditController.clear();
    _singleBetLimitationEditController.clear();
    _commisionEditController.clear();
    _highCommisionEditController.clear();
    _mcTwoCommisionEditController.clear();
    _mcThreeCommisionEditController.clear();
    _mcFourCommisionEditController.clear();
    _mcFiveCommisionEditController.clear();
    _mcSixCommisionEditController.clear();
    _mcSevenCommisionEditController.clear();
    _mcEightCommisionEditController.clear();
    _mcNineCommisionEditController.clear();
    _mcTenCommisionEditController.clear();
    _mcElevenCommisionEditController.clear();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchMemberDetails(widget.userId);
    }
  }

  Future<void> _fetchMemberDetails(int userID) async {
    var url = Uri.parse('${Config.apiUrl}/getUserDetails/$userID');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userDetailsJson = data['user_details'][0];
      final singleCommissionsJson = data['single_commissions'][0];
      final mixCommissionsJson = data['mix_commissions'][0];
      setState(() {
        _userDetails = UserDetails.fromJson(userDetailsJson);
        _singleCommissions = SingleCommissions.fromJson(singleCommissionsJson);
        _mixCommissions = MixCommissions.fromJson(mixCommissionsJson);
      });
    } else {}
  }

  Future<void> _editBasicInfo(int userID) async {
    var url = Uri.parse('${Config.apiUrl}/editBasicInfo/$userID');
    final response = await http.post(url, headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer $_token'
    }, body: {
      'realname': _nameEditController.text,
      'phone_number': _phoneNumberEditController.text
    });
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Editing Basic Info Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Editing Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _manageUnits() async {
    final action = _radioValue == 1 ? 'add' : 'remove';
    final amount = _amountController.text;

    var url = Uri.parse('${Config.apiUrl}/manageUnits');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
        'amount': amount,
        'action': action,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Managing Units Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Managing Units Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _editMaxLimit() async {
    var url = Uri.parse('${Config.apiUrl}/editBetLimit');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
        'maxSingleBet': _singleBetLimitationEditController.text,
        'maxMixBet': _mixBetLimitationEditController.text,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Changing Max Limit Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Changing Max Limit Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateMixCommission(String matchType, String commission) async {
    var url = Uri.parse('${Config.apiUrl}/editMix3to11Commissions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
        'match_type': matchType,
        'commission': commission,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Mix Commision Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Mix Commision Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _updateMix2Commission(
      String matchType, String commission) async {
    var url = Uri.parse('${Config.apiUrl}/editMix2Commissions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
        'match_type': matchType,
        'commission': commission,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Mix Commision Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Mix Commision Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _SingleCommissions() async {
    var url = Uri.parse('${Config.apiUrl}/SingleCommissions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
        'commissions': _commisionEditController.text,
        'high_commissions': _highCommisionEditController.text
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Single Commision Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Single Commision Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _resetPassword() async {
    var url = Uri.parse('${Config.apiUrl}/change_password');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
        'new_password': _newPasswordController.text,
        'new_password_confirmation': _confirmNewPasswordController.text
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Password Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Updating Password Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _suspendUser() async {
    var url = Uri.parse('${Config.apiUrl}/suspend_user');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Suspending Account Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    _userDetails!.status = 'suspended';
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Suspending Account Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> _unsuspendUser() async {
    var url = Uri.parse('${Config.apiUrl}/unsuspend_user');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user_id': widget.userId,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsuspending Account Succeed!'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    _userDetails!.status = 'active';
                    Navigator.pop(context);
                    setState(() {
                      clearForms();
                      _getToken();
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsuspending Account Failed!'),
          content: Text(response.body),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _userDetails == null ||
            _singleCommissions == null ||
            _mixCommissions == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: bigCapText('Basic Info'),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  color: kBlue,
                                  onPressed: () {
                                    basicInfoEditDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('Name'),
                                    labelText('Username'),
                                    labelText('Mobile'),
                                    labelText('Balance'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('-'),
                                    labelText('-'),
                                    labelText('-'),
                                    labelText('-'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText(_userDetails!.realname),
                                    labelText(_userDetails!.username),
                                    labelText(_userDetails!.phoneNumber),
                                    labelText(_userDetails!.balance),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                  child: materialButton(
                                      kSecondary, 'Reset Password', () {
                                resetPasswordDialog(context);
                              })),
                              const SizedBox(width: 5.0),
                              Expanded(
                                  child: materialButton(
                                      kError, 'Manage Balance', () {
                                manageBalanceDialog(context);
                              })),
                              const SizedBox(width: 5.0),
                              Expanded(
                                  child: _userDetails!.status == 'active'
                                      ? materialButton(kGreen, 'Suspend', () {
                                          _suspendUser();
                                        })
                                      : materialButton(kGrey, 'Unsuspend', () {
                                          _unsuspendUser();
                                        })),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: bigCapText('Share Detail'),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  color: kBlue,
                                  onPressed: () {
                                    shareDetailDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('Share Percentage'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('-'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('0'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: bigCapText('Bet Limitations'),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  color: kBlue,
                                  onPressed: () {
                                    betLimitationsDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('Single Bet Limitation'),
                                    labelText('Mix Bet Limitation'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('-'),
                                    labelText('-'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText(_userDetails!.maxSingleBet),
                                    labelText(_userDetails!.maxMixBet),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: bigCapText('Single Bet Commission'),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  color: kBlue,
                                  onPressed: () {
                                    singleBetCommisionDialog(context);
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: labelText('Commission')),
                                        Expanded(
                                            flex: 1, child: labelText('-')),
                                        Expanded(
                                          flex: 3,
                                          child: labelText(_singleCommissions!
                                              .low
                                              .toString()),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 5, child: labelText('Tax')),
                                        Expanded(
                                            flex: 1, child: labelText('-')),
                                        Expanded(
                                            flex: 3, child: labelText('5')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child:
                                                labelText('High Commission')),
                                        Expanded(
                                            flex: 1, child: labelText('-')),
                                        Expanded(
                                          flex: 3,
                                          child: labelText(_singleCommissions!
                                              .high
                                              .toString()),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: labelText('High Tax')),
                                        Expanded(
                                            flex: 1, child: labelText('-')),
                                        Expanded(
                                            flex: 3, child: labelText('8')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: bigCapText('Mix Bet Commission'),
                          ),
                          const Divider(),
                          Container(
                            child: MixBetCommissionView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
  }

  Widget MixBetCommissionView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: listTitleText('Match Count'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Tax'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Commission'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Action'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 300, // Set a fixed height
            child: Column(
              children: [
                ListCard(
                    matchCount: '2',
                    tax: '15',
                    commission: _mixCommissions!.m2.toString(),
                    onPressed: () {
                      mcTwoCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '3',
                    tax: '20',
                    commission: _mixCommissions!.m3.toString(),
                    onPressed: () {
                      mcThreeCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '4',
                    tax: '20',
                    commission: _mixCommissions!.m4.toString(),
                    onPressed: () {
                      mcFourCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '5',
                    tax: '20',
                    commission: _mixCommissions!.m5.toString(),
                    onPressed: () {
                      mcFiveCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '6',
                    tax: '20',
                    commission: _mixCommissions!.m6.toString(),
                    onPressed: () {
                      mcSixCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '7',
                    tax: '20',
                    commission: _mixCommissions!.m7.toString(),
                    onPressed: () {
                      mcSevenCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '8',
                    tax: '20',
                    commission: _mixCommissions!.m8.toString(),
                    onPressed: () {
                      mcEightCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '9',
                    tax: '20',
                    commission: _mixCommissions!.m9.toString(),
                    onPressed: () {
                      mcNineCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '10',
                    tax: '20',
                    commission: _mixCommissions!.m10.toString(),
                    onPressed: () {
                      mcTenCommisionDialog(context);
                    }),
                ListCard(
                    matchCount: '11',
                    tax: '20',
                    commission: _mixCommissions!.m11.toString(),
                    onPressed: () {
                      mcElevenCommisionDialog(context);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ListCard({
    required String matchCount,
    required String tax,
    required String commission,
    required Function onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: listText(matchCount),
        ),
        Expanded(
          flex: 3,
          child: listText(tax),
        ),
        Expanded(
          flex: 5,
          child: listText(commission),
        ),
        Expanded(
          flex: 3,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.topLeft,
              child: const Icon(
                Icons.edit_outlined,
                color: kBlue,
                size: 20,
              ),
            ),
            onTap: () {
              onPressed();
            },
          ),
        ),
      ],
    );
  }

  //THESE ARE THE CONTROLLERS
  //THESE ARE THE CONTROLLERS
  //THESE ARE THE CONTROLLERS

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _phoneNumberEditController =
      TextEditingController();
  final TextEditingController _sharePercentageEditController =
      TextEditingController();
  final TextEditingController _mixBetLimitationEditController =
      TextEditingController();
  final TextEditingController _singleBetLimitationEditController =
      TextEditingController();
  final TextEditingController _commisionEditController =
      TextEditingController();
  final TextEditingController _highCommisionEditController =
      TextEditingController();
  final TextEditingController _mcTwoCommisionEditController =
      TextEditingController();
  final TextEditingController _mcThreeCommisionEditController =
      TextEditingController();
  final TextEditingController _mcFourCommisionEditController =
      TextEditingController();
  final TextEditingController _mcFiveCommisionEditController =
      TextEditingController();
  final TextEditingController _mcSixCommisionEditController =
      TextEditingController();
  final TextEditingController _mcSevenCommisionEditController =
      TextEditingController();
  final TextEditingController _mcEightCommisionEditController =
      TextEditingController();
  final TextEditingController _mcNineCommisionEditController =
      TextEditingController();
  final TextEditingController _mcTenCommisionEditController =
      TextEditingController();
  final TextEditingController _mcElevenCommisionEditController =
      TextEditingController();
  int _radioValue = 0; // Default radio button value

  void resetPasswordDialog(BuildContext context) {
    bool newPasswordObsecureText = true;
    bool confirmNewPasswordObsecureText = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Reset password'),
                    const Divider(),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: newPasswordObsecureText,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            newPasswordObsecureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              newPasswordObsecureText =
                                  !newPasswordObsecureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      obscureText: confirmNewPasswordObsecureText,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            confirmNewPasswordObsecureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              confirmNewPasswordObsecureText =
                                  !confirmNewPasswordObsecureText;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _resetPasswordAskDialog(context);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _resetPasswordAskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset Password?"),
          content:
              const Text('Do you really want to reset password of this account?'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: materialButton(
                      kError,
                      'Cancel',
                      () {},
                    )),
                const SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      _resetPassword();
                      Navigator.pop(context);
                    })),
              ],
            )
          ],
        );
      },
    );
  }

  void manageBalanceDialog(BuildContext context) {
    // Define state variables for radio buttons and checkbox
    // Default checkbox value
    bool checkboxValue = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: IntrinsicWidth(
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bigCapText('Reset password'),
                        const Divider(),
                        // Add Radio widgets inside a Row
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<int>(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _radioValue = value!;
                                      });
                                    },
                                  ),
                                  labelText('Add'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio<int>(
                                    value: 2,
                                    groupValue: _radioValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _radioValue = value!;
                                      });
                                    },
                                  ),
                                  labelText('Remove'),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        TextFormField(
                          controller: _amountController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Amount',
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        // Add CheckboxListTile widget here
                        CheckboxListTile(
                          title: const Text('Credit'),
                          value: checkboxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxValue = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                                child: materialButton(kError, 'Cancel', () {
                              Navigator.pop(context);
                            })),
                            const SizedBox(width: 5.0),
                            Expanded(
                                child: materialButton(kBlue, 'Save', () {
                              _manageBalanceAskDialog(context);
                            })),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _manageBalanceAskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Manage Balance?"),
          content: _radioValue == 1
              ? Text(
                  'Do you really want add ${_amountController.text} to this account?')
              : Text(
                  'Do you really want reduce ${_amountController.text} from this account?'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: materialButton(
                      kError,
                      'Cancel',
                      () {},
                    )),
                const SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      _manageUnits();
                      Navigator.pop(context);
                    })),
              ],
            )
          ],
        );
      },
    );
  }

  void basicInfoEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Basic Info'),
                    const Divider(),
                    TextFormField(
                      controller: _nameEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Name',
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      controller: _phoneNumberEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Phone Number',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _editBasicInfo(widget.userId);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void shareDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Share Detail'),
                    const Divider(),
                    TextFormField(
                      controller: _sharePercentageEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Share Percentage',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(child: materialButton(kBlue, 'Save', () {})),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void betLimitationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Bet Limitation'),
                    const Divider(),
                    TextFormField(
                      controller: _mixBetLimitationEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Mix Bet Limitation',
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      controller: _singleBetLimitationEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Single Bet Limitation',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _editMaxLimit();
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void singleBetCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Edit Single Bet Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _commisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Commision',
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    TextFormField(
                      controller: _highCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'High Commision',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _SingleCommissions();
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///MIXED BET COMMISION DIALOGS
  void mcTwoCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 2 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcTwoCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '7',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMix2Commission(
                              'm2', _mcTwoCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcThreeCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 3 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcThreeCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm3', _mcThreeCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcFourCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 4 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcFourCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm4', _mcFourCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcFiveCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 5 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcFiveCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm5', _mcFiveCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcSixCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 6 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcSixCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm6', _mcSixCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcSevenCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 7 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcSevenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm7', _mcSevenCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcEightCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 8 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcEightCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm8', _mcEightCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcNineCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 9 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcNineCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm9', _mcNineCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcTenCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 10 Matches Commision Controller'),
                    const Divider(),
                    TextFormField(
                      controller: _mcTenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm10', _mcTenCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void mcElevenCommisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigCapText('Mix Bet 11 Matches Commision'),
                    const Divider(),
                    TextFormField(
                      controller: _mcElevenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        const SizedBox(width: 5.0),
                        Expanded(
                            child: materialButton(kBlue, 'Save', () {
                          _updateMixCommission(
                              'm11', _mcElevenCommisionEditController.text);
                        })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
