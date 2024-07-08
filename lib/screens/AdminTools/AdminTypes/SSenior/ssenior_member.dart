import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SSeniorMembers extends StatefulWidget {
  static String id = 'ssenior_member_page';
  const SSeniorMembers({super.key});

  @override
  State<SSeniorMembers> createState() => _SSeniorMembersState();
}

class _SSeniorMembersState extends State<SSeniorMembers> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _maxMixBetController = TextEditingController();
  final TextEditingController _maxSingleBetController = TextEditingController();
  final TextEditingController _sharePercentageController =
      TextEditingController();
  final TextEditingController _singleBetCommisionController =
      TextEditingController();
  final TextEditingController _singleBetHighCommisionController =
      TextEditingController();
  final TextEditingController _mixBet2Commision = TextEditingController();
  final TextEditingController _mixBet3Commision = TextEditingController();
  final TextEditingController _mixBet4Commision = TextEditingController();
  final TextEditingController _mixBet5Commision = TextEditingController();
  final TextEditingController _mixBet6Commision = TextEditingController();
  final TextEditingController _mixBet7Commision = TextEditingController();
  final TextEditingController _mixBet8Commision = TextEditingController();
  final TextEditingController _mixBet9Commision = TextEditingController();
  final TextEditingController _mixBet10Commision = TextEditingController();
  final TextEditingController _mixBet11Commision = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool _passwordObsecureText = true;
  bool _confirmPasswordObsecureText = true;

  String? selectedValue1;
  String? selectedValue2;
  String? selectedValue;
  String? _token;
  String? _username;
  String? _role;

  @override
  void initState() {
    _role = 'Loading...';
    _username = 'Loading...';
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _balanceController.dispose();
    _confirmPasswordController.dispose();

    _maxMixBetController.dispose();
    _maxSingleBetController.dispose();
    _sharePercentageController.dispose();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data or perform necessary actions
    _getToken();
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
                        showUsername(_username!),
                        showAccountType(_role!)
                      ],
                    )),
                    materialButton(kBlue, 'View Member List', () {
                      Navigator.pushNamed(context, SSSeniorShowMembersList.id);
                    }),
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
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              DropdownButtonHideUnderline(
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
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
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
                                  value: selectedValue1,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue1 = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
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
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              DropdownButtonHideUnderline(
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
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
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
                                  value: selectedValue2,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue2 = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    width: 160,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
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
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      labelText('Name'),
                      TextFormField(
                        controller: _nameController,
                        style: kTextFieldActiveStyle,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Name'),
                      ),
                      const SizedBox(height: 10.0),
                      labelText('Phone Number'),
                      TextFormField(
                        controller: _phoneNumberController,
                        style: kTextFieldActiveStyle,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter phone number'),
                      ),
                      const SizedBox(height: 10.0),
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
                                  obscureText: _passwordObsecureText,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _passwordObsecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _passwordObsecureText =
                                              !_passwordObsecureText;
                                        });
                                      },
                                    ),
                                  ),
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
                                  obscureText: _confirmPasswordObsecureText,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Confirm password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _confirmPasswordObsecureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _confirmPasswordObsecureText =
                                              !_confirmPasswordObsecureText;
                                        });
                                      },
                                    ),
                                  ),
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
                                  controller: _maxMixBetController,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: '0'),
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  'Max Bet Amount for Mix Bet : 000000',
                                  style: TextStyle(fontSize: 12.0),
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
                                  controller: _maxSingleBetController,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: '0'),
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  'Max Bet Amount for Single Bet : 000000',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      bigCapText('Share Detail'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelText('Share Percentage'),
                          TextFormField(
                            controller: _sharePercentageController,
                            style: kTextFieldActiveStyle,
                            decoration:
                                kTextFieldDecoration.copyWith(hintText: '0'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      bigCapText('Single Bet Commision'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelText('Commision'),
                                TextFormField(
                                  controller: _singleBetCommisionController,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: '0'),
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  'Tax: 5',
                                  style: TextStyle(fontSize: 12.0),
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
                                labelText('High Commision'),
                                TextFormField(
                                  controller: _singleBetHighCommisionController,
                                  style: kTextFieldActiveStyle,
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: '0'),
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  'High Tax: 8',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      bigCapText('Mix Bet Commisions'),
                      Column(
                        children: [
                          matchCounts(2, 15, _mixBet2Commision),
                          matchCounts(3, 20, _mixBet3Commision),
                          matchCounts(4, 20, _mixBet4Commision),
                          matchCounts(5, 20, _mixBet5Commision),
                          matchCounts(6, 20, _mixBet6Commision),
                          matchCounts(7, 20, _mixBet7Commision),
                          matchCounts(8, 20, _mixBet8Commision),
                          matchCounts(9, 20, _mixBet9Commision),
                          matchCounts(10, 20, _mixBet10Commision),
                          matchCounts(11, 20, _mixBet11Commision),
                        ],
                      ),
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
                                            Navigator.pop(context);
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

  Widget matchCounts(
      int matchCountNumber, int tax, TextEditingController controller) {
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

  Future<void> _register() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/register');
    var response = await http.post(url, headers: {
      'Accept': 'Application/json',
      'Authorization': 'Bearer $_token',
    }, body: {
      'realname': _nameController.text,
      'username': _username! + selectedValue1! + selectedValue2!,
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
      'phone_number': _phoneNumberController.text,
      'balance': _balanceController.text,
    });

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Succeed.'),
          content: const Text('Click OK to close this dialog.'),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })),
              ],
            ),
          ],
        ),
      );
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> errors = responseData['errors'];
      String errorMessage = "";
      errors.forEach((key, value) {
        errorMessage += "$key: $value\n";
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Errors'),
          content: Text(errorMessage),
          actions: <Widget>[
            Row(
              children: [
                Expanded(flex: 1, child: Container()),
                SizedBox(width: 5.0),
                Expanded(
                    flex: 1,
                    child: materialButton(kBlue, 'OK', () {
                      Navigator.pop(context);
                    })),
              ],
            ),
          ],
        ),
      );
    }
  }
}
