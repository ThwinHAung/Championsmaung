import 'dart:convert';

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

  UserDetails({
    required this.realname,
    required this.username,
    required this.phoneNumber,
    required this.balance,
    required this.maxSingleBet,
    required this.maxMixBet,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      realname: json['realname'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      balance: json['balance'],
      maxSingleBet: json['maxSingleBet'],
      maxMixBet: json['maxMixBet'],
    );
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

class MasterDetailsTab extends StatefulWidget {
  final int userId;
  const MasterDetailsTab({Key? key, required this.userId}) : super(key: key);

  @override
  State<MasterDetailsTab> createState() => _MasterDetailsTabState();
}

class _MasterDetailsTabState extends State<MasterDetailsTab> {
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

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchMemberDetails(widget.userId);
    }
  }

  Future<void> _fetchMemberDetails(int userID) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/getUserDetails/$userID');
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

  @override
  Widget build(BuildContext context) {
    return _userDetails == null ||
            _singleCommissions == null ||
            _mixCommissions == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0),
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
                                  icon: Icon(
                                    Icons.edit_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
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
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                  child: materialButton(
                                      kSecondary, 'Reset Password', () {
                                resetPasswordDialog(context);
                              })),
                              SizedBox(width: 5.0),
                              Expanded(
                                  child: materialButton(
                                      kError, 'Manage Balance', () {
                                manageBalanceDialog(context);
                              })),
                              SizedBox(width: 5.0),
                              Expanded(
                                  child:
                                      materialButton(kGreen, 'Suspend', () {})),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
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
              child: Icon(
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
  final TextEditingController _mixBetLimitationEditController =
      TextEditingController();
  final TextEditingController _singleBetLimitationEditController =
      TextEditingController();

  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _phoneNumberEditController =
      TextEditingController();

  void resetPasswordDialog(BuildContext context) {
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
                    Divider(),
                    TextFormField(
                      controller: _newPasswordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'New Password',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _confirmNewPasswordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Confrim New Password',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
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

  void manageBalanceDialog(BuildContext context) {
    // Define state variables for radio buttons and checkbox
    int _radioValue = 0; // Default radio button value
    bool _checkboxValue = false; // Default checkbox value

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
                        Divider(),
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
                            SizedBox(width: 5.0),
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
                        SizedBox(height: 5.0),
                        TextFormField(
                          controller: _amountController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Amount',
                          ),
                        ),
                        SizedBox(height: 5.0),
                        // Add CheckboxListTile widget here
                        CheckboxListTile(
                          title: const Text('Credit'),
                          value: _checkboxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              _checkboxValue = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                                child: materialButton(kError, 'Cancel', () {
                              Navigator.pop(context);
                            })),
                            SizedBox(width: 5.0),
                            Expanded(
                                child: materialButton(kBlue, 'Save', () {})),
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
                    Divider(),
                    TextFormField(
                      controller: _nameEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Name',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _phoneNumberEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Phone Number',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
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
                    Divider(),
                    TextFormField(
                      controller: _mixBetLimitationEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Mix Bet Limitation',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _singleBetLimitationEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Single Bet Limitation',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                            child: materialButton(kError, 'Cancel', () {
                          Navigator.pop(context);
                        })),
                        SizedBox(width: 5.0),
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
}
