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

class DetailsTab extends StatefulWidget {
  final int userId;
  const DetailsTab({Key? key, required this.userId}) : super(key: key);

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
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
                  SizedBox(height: 10.0),
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
                  SizedBox(height: 10.0),
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
                                    labelText('Mix Bet Limitation'),
                                    labelText('Single Bet Limitation'),
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
                  SizedBox(height: 10.0),
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
                                    labelText('Commission'),
                                    labelText('Tax'),
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
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText(
                                        _singleCommissions!.low.toString()),
                                    labelText('5'),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText('High Commission'),
                                    labelText('High Tax'),
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
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    labelText(
                                        _singleCommissions!.high.toString()),
                                    labelText('8'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
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
                            child: bigCapText('Mix Bet Commission'),
                            alignment: Alignment.topLeft,
                          ),
                          Divider(),
                          Container(
                            child: MixBetCommissionView(),
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
          Container(
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
                    Divider(),
                    TextFormField(
                      controller: _sharePercentageEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Share Percentage',
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
                    Divider(),
                    TextFormField(
                      controller: _commisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Commision',
                      ),
                    ),
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: _highCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'High Commision',
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

  void mixBetCommisionDialog(BuildContext context) {
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
                    Divider(),
                    TextFormField(
                      controller: _mcTwoCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '7',
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
                    Divider(),
                    TextFormField(
                      controller: _mcThreeCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcFourCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcFiveCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcSixCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcSevenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcEightCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcNineCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcTenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
                    Divider(),
                    TextFormField(
                      controller: _mcElevenCommisionEditController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: '15',
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
