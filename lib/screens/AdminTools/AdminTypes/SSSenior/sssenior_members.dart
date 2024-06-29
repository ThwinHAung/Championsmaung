import 'dart:async';
import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaxData {
  final int id; // ID from the taxes table
  final int matchCount;
  final double taxRate;
  final String? calculateOn;

  TaxData({
    required this.id,
    required this.matchCount,
    required this.taxRate,
    this.calculateOn,
  });

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      id: json['id'],
      matchCount: json['match_count'],
      taxRate: double.parse(json['tax_rate']),
      calculateOn: json['calculateOn'],
    );
  }
}

class SSSeniorMembers extends StatefulWidget {
  static String id = 'sssenior_member_page';
  const SSSeniorMembers({super.key});

  @override
  State<SSSeniorMembers> createState() => _SSSeniorMembersState();
}

class _SSSeniorMembersState extends State<SSSeniorMembers> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _mixBetController = TextEditingController();
  final TextEditingController _singleBetController = TextEditingController();
  final TextEditingController _singleBetCommisionController =
      TextEditingController();
  final TextEditingController _singleBetHighCommisionController =
      TextEditingController();
  final TextEditingController _mixBet2Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet3Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet4Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet5Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet6Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet7Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet8Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet9Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet10Commision =
      TextEditingController(text: '0');
  final TextEditingController _mixBet11Commision =
      TextEditingController(text: '0');
  final storage = const FlutterSecureStorage();

  String? selectedValue;
  String? _token;
  String? _username;
  String? _role;
  late Future<List<TaxData>> futureTaxData = Future.value([]);
  List<TextEditingController> commissionControllers = [];

  void createControllers(List<TaxData> taxDataList) {
    commissionControllers.clear(); // Clear existing controllers
    for (var i = 0; i < taxDataList.length; i++) {
      commissionControllers.add(TextEditingController(text: '0'));
    }
  }

  @override
  void initState() {
    _role = 'Loading...';
    _username = 'Loading...';
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _balanceController.dispose();
    _confirmPasswordController.dispose();

    _mixBetController.dispose();
    _singleBetController.dispose();
    _singleBetCommisionController.dispose();
    _singleBetHighCommisionController.dispose();
    _mixBet2Commision.dispose();
    _mixBet3Commision.dispose();
    _mixBet4Commision.dispose();
    _mixBet5Commision.dispose();
    _mixBet6Commision.dispose();
    _mixBet7Commision.dispose();
    _mixBet8Commision.dispose();
    _mixBet9Commision.dispose();
    _mixBet10Commision.dispose();
    _mixBet11Commision.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    final String? role = await storage.read(key: 'user_role');
    final String? username = await storage.read(key: 'user_name');

    if (role != null && username != null) {
      setState(() {
        _role = role;
        _username = username;
      });
    }

    if (_token != null) {
      futureTaxData = _fetchTaxData();
    }
  }

  Future<List<TaxData>> _fetchTaxData() async {
    var url = Uri.parse('https://www.championmaung.com/api/retrievetaxes');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      });

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => TaxData.fromJson(item)).toList();
      } else {
        // Handle other status codes appropriately, maybe return an empty list
        return [];
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      return [];
    }
  }

  Future<void> _register() async {
    var url = Uri.parse('https://www.championmaung.com/api/register');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      'username': selectedValue,
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
      'phone_number': _phoneNumberController.text,
      'balance': _balanceController.text,
    });

    if (response.statusCode == 200) {
      // int userId = json.decode(response.body)['user_id'];
      // Insert commissions and their IDs if needed

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Succeed.'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
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
      ).then((_) {
        // Navigate back after dialog is closed
        Navigator.pop(context);
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> errors = responseData['errors'];
      String errorMessage = "";
      errors.forEach((key, value) {
        errorMessage += "$key: $value\n";
      });

      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                const SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      Navigator.pop(context);
                    }))
              ],
            ),
          ],
        ),
      );
    }
  }

  // Future<void> _register() async {
  //   var url = Uri.parse('http://127.0.0.1:8000/api/register');
  //   var response = await http.post(url, headers: {
  //     'Authorization': 'Bearer $_token',
  //   }, body: {
  //     'username': selectedValue,
  //     'password': _passwordController.text,
  //     'password_confirmation': _confirmPasswordController.text,
  //     'phone_number': _phoneNumberController.text,
  //     'balance': _balanceController.text,
  //   });

  //   if (response.statusCode == 200) {
  //     int userId = json.decode(response.body)['user_id'];

  //     // Insert commissions and their IDs
  //     // List<Map<String, dynamic>> commissionsList = [];
  //     //
  //     // List<TaxData> taxDataList = await futureTaxData;
  //     //
  //     // for (int i = 0; i < taxDataList.length; i++) {
  //     //   TaxData taxData = taxDataList[i];
  //     //   TextEditingController controller = commissionControllers[i];
  //     //   if (controller.text.isNotEmpty) {
  //     //     commissionsList.add({
  //     //       'user_id': userId,
  //     //       'match_count': taxData.id,
  //     //       'percent': controller.text, // Use the controller value here
  //     //     });
  //     //   }
  //     // }
  //     //
  //     // var commissionsUrl =
  //     //     Uri.parse('http://127.0.0.1:8000/api/addingCommissions');
  //     // var commissionsResponse = await http.post(commissionsUrl, headers: {
  //     //   'Authorization': 'Bearer $_token',
  //     // }, body: {
  //     //   'commissions': json.encode(commissionsList),
  //     // });
  //     // if (response.statusCode == 200) {
  //     //   print('hello');
  //     // } else {
  //     //   print(response.body);
  //     // }

  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Succeed.'),
  //         content: const Text('Click OK to close this dialog.'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //     Navigator.pop(context);
  //   } else {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     final Map<String, dynamic> errors = responseData['errors'];
  //     String errorMessage = "";
  //     errors.forEach((key, value) {
  //       errorMessage += "$key: $value\n";
  //     });
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Error'),
  //         content: Text(errorMessage),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  Future<void> _insertCommission(
      int userId, int matchCountId, String percent) async {
    var url = Uri.parse('https://www.championmaung.com/api/commissions');
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'match_count': matchCountId,
          'percent': percent,
        }));

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Commission added successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to add commission'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
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
          'Create Account',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showUsername('$_username'),
                          showAccountType('$_role'),
                        ],
                      ),
                    ),
                    materialButton(kBlue, 'View Member List', () {}),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelText('Select Username'),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: const Row(
                                children: [
                                  Icon(
                                    Icons.list,
                                    size: 16,
                                    color: kPrimary,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Select',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: userDropdownItems
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: kBlue,
                                  ),
                                  color: kBlue,
                                ),
                                elevation: 2,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor: kPrimary,
                                iconDisabledColor: kGrey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: kBlue,
                                ),
                                offset: const Offset(-20, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      bigCapText('Basic Info'),
                      labelText('Phone Number'),
                      TextFormField(
                        controller: _phoneNumberController,
                        style: kTextFieldActiveStyle,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter phone number'),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText('Password'),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Enter password'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText('Confirm Password'),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Confirm password'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      labelText('Starting Balance'),
                      TextFormField(
                        controller: _balanceController,
                        style: kTextFieldActiveStyle,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter starting balance'),
                      ),
                      const SizedBox(height: 30.0),
                      bigCapText('Bet Limitation'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText('Max for Mix Bet'),
                                TextFormField(
                                  controller: _mixBetController,
                                  obscureText: true,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: '0'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText('Max for Single Bet'),
                                TextFormField(
                                  controller: _singleBetController,
                                  obscureText: true,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: '0'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 30.0),
                      // bigCapText('Single Bet Commision'),
                      // FutureBuilder<List<TaxData>>(
                      //   future: futureTaxData,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const Center(
                      //           child: CircularProgressIndicator());
                      //     } else if (snapshot.hasError) {
                      //       return Center(
                      //           child: Text('Error: ${snapshot.error}'));
                      //     } else {
                      //       List<TaxData> taxDataList = snapshot.data!;
                      //       return Column(
                      //         children: [
                      //           for (var taxData in taxDataList)
                      //             matchCounts(
                      //               taxData.matchCount,
                      //               taxData.taxRate.toInt(),
                      //               taxData
                      //                   .calculateOn, // Pass your controller here
                      //             ),
                      //         ],
                      //       );
                      //     }
                      //   },
                      // ),
                      const SizedBox(height: 30.0),
                      Container(
                        alignment: Alignment.topRight,
                        child: Material(
                          color: kBlue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Do you want to create account?',
                                    style: kLabel,
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: materialButton(
                                                kError, 'Cancel', () {
                                              Navigator.pop(context);
                                            })),
                                        const SizedBox(width: 5.0),
                                        Expanded(
                                          flex: 1,
                                          child: materialButton(
                                              kBlue, 'Confirm', () {
                                            (_register());
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ); //Implement registration functionality.
                            },
                            minWidth: 200.0,
                            height: 42.0,
                            child: const Text(
                              'Create Account',
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget matchCounts(int matchCountNumber, int tax, String? calculateOn) {
    TextEditingController controller =
        commissionControllers.length > matchCountNumber - 1
            ? commissionControllers[matchCountNumber - 1]
            : TextEditingController();

    if (matchCountNumber == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (calculateOn == 'Low')
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText('Commision'),
                  TextFormField(
                    controller: controller,
                    obscureText: true,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(hintText: '0'),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Tax: $tax',
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
          if (calculateOn != 'Low')
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText('High Commision'),
                  TextFormField(
                    controller: TextEditingController(),
                    obscureText: true,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(hintText: '0'),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'High Tax: $tax',
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelText('Match Count'),
                labelText(matchCountNumber.toString()),
              ],
            ),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelText('Tax'),
                labelText(tax.toString()),
              ],
            ),
          ),
          const SizedBox(width: 5.0),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller,
                  obscureText: true,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(hintText: '0'),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      );
    }
  }
}
