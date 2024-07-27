import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AgentMembers extends StatefulWidget {
  static String id = 'agent_member_page';
  const AgentMembers({super.key});

  @override
  State<AgentMembers> createState() => _AgentMembersState();
}

class _AgentMembersState extends State<AgentMembers> {
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
  final TextEditingController _singleBetCommissionController =
      TextEditingController();
  final TextEditingController _singleBetHighCommissionController =
      TextEditingController();
  final TextEditingController _mixBet2CommissionController =
      TextEditingController();
  final TextEditingController _mixBet3CommissionController =
      TextEditingController();
  final TextEditingController _mixBet4CommissionController =
      TextEditingController();
  final TextEditingController _mixBet5CommissionController =
      TextEditingController();
  final TextEditingController _mixBet6CommissionController =
      TextEditingController();
  final TextEditingController _mixBet7CommissionController =
      TextEditingController();
  final TextEditingController _mixBet8CommissionController =
      TextEditingController();
  final TextEditingController _mixBet9CommissionController =
      TextEditingController();
  final TextEditingController _mixBet10CommissionController =
      TextEditingController();
  final TextEditingController _mixBet11CommissionController =
      TextEditingController();
  final storage = const FlutterSecureStorage();

  bool _passwordObsecureText = true;
  bool _confirmPasswordObsecureText = true;

  String? selectedValue1;
  String? selectedValue2;
  String? selectedValue;
  String? _token;
  String? _username;
  String? _role;
  String? _maxSingleBet;
  String? _maxMixBet;

  @override
  void initState() {
    _role = 'Loading...';
    _username = 'Loading...';
    _maxSingleBet = 'Loading...';
    _maxMixBet = 'Loading...';
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
    _singleBetCommissionController.dispose();
    _singleBetHighCommissionController.dispose();
    _mixBet2CommissionController.dispose();
    _mixBet3CommissionController.dispose();
    _mixBet4CommissionController.dispose();
    _mixBet5CommissionController.dispose();
    _mixBet6CommissionController.dispose();
    _mixBet7CommissionController.dispose();
    _mixBet8CommissionController.dispose();
    _mixBet9CommissionController.dispose();
    _mixBet10CommissionController.dispose();
    _mixBet11CommissionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data or perform necessary actions
    _getToken();
    _resetDropdown();
  }

  void _resetDropdown() {
    setState(() {
      selectedValue = null;
      selectedValue1 = null; // or set to a default value if required
      selectedValue2 = null; // or set to a default value if required
      // or set to a default value if required
    });
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
      if (_token != null && _username != null) {
        _getMaxBetAmount(_username!);
      }
    }
  }

  Future<void> _getMaxBetAmount(String username) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/maxAmountBets/$username');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $_token',
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _maxSingleBet = data['maxSingleBet'].toString();
        _maxMixBet = data['maxMixBet'].toString();
      });
    } else {
      print(response.body);
      setState(() {
        _maxSingleBet = 'Error fetching data';
        _maxMixBet = 'Error fetching data';
      });
    }
  }

  Future<void> _register() async {
    // Check if selectedValue1 or selectedValue2 is null
    if (selectedValue1 == null || selectedValue2 == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select both values for username.'),
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
      return; // Exit the method early if either value is null
    }

    var url = Uri.parse('http://127.0.0.1:8000/api/register');
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'realname': _nameController.text,
        'username': _username! + selectedValue1! + selectedValue2!,
        'password': _passwordController.text,
        'password_confirmation': _confirmPasswordController.text,
        'phone_number': _phoneNumberController.text,
        'balance': _balanceController.text,
        'maxSingleBet': _maxSingleBetController.text,
        'maxMixBet': _maxMixBetController.text,
        'high': _singleBetHighCommissionController.text,
        'low': _singleBetCommissionController.text,
        'mixBet2Commission': _mixBet2CommissionController.text,
        'mixBet3Commission': _mixBet3CommissionController.text,
        'mixBet4Commission': _mixBet4CommissionController.text,
        'mixBet5Commission': _mixBet5CommissionController.text,
        'mixBet6Commission': _mixBet6CommissionController.text,
        'mixBet7Commission': _mixBet7CommissionController.text,
        'mixBet8Commission': _mixBet8CommissionController.text,
        'mixBet9Commission': _mixBet9CommissionController.text,
        'mixBet10Commission': _mixBet10CommissionController.text,
        'mixBet11Commission': _mixBet11CommissionController.text,
      }),
    );

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
                const SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: materialButton(kBlue, 'OK', () {
                    _resetDropdown();
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ],
        ),
      ).then((_) {
        Navigator.pop(context);
      });
    } else {
      print(response.body); // Log the complete response body for debugging
      final Map<String, dynamic> responseData = json.decode(response.body);
      String errorMessage = "";

      if (responseData['message'] == 'Fill all fields') {
        errorMessage = 'Fill all fields';
      } else {
        if (responseData['message'] is String) {
          errorMessage = responseData['message'];
        } else if (responseData['message'] is List) {
          responseData['message'].forEach((error) {
            errorMessage += "$error\n";
          });
        } else if (responseData['message'] is Map) {
          responseData['message'].forEach((key, value) {
            errorMessage += "$key: $value\n";
          });
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
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
                                Text(
                                  'Max Bet Amount for Mix Bet : $_maxSingleBet',
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
                                Text(
                                  'Max Bet Amount for Single Bet : $_maxMixBet',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
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
                                            Navigator.pop(context);
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
}
