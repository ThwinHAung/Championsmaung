import 'package:champion_maung/constants.dart';
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
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final storage = FlutterSecureStorage();
  String? selectedValue1;
  String? selectedValue2;
  String? _token;
  String? _role;
  String? _userId;

  @override
  void initState() {
    _role = 'Loading...';
    _userId = 'Loading...';
    _getToken();
    super.initState();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    final String? role = await storage.read(key: 'user_role');
    final String? userId = await storage.read(key: 'user_id');

    if (role != null && userId != null) {
      setState(() {
        _role = role;
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: kPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'Your account type : $_role',
                        style: TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  materialButton(kBlue, 'View Member List', () {}),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Username : '),
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
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
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
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
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
                    labelText('Password'),
                    TextFormField(
                      controller: _passwordController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter password'),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    labelText('Confirm Password'),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Confirm password'),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    labelText('Starting Balance'),
                    TextFormField(
                      controller: _balanceController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter starting balance'),
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
                                  Material(
                                    color: kOnPrimaryContainer,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    elevation: 5.0,
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      minWidth: 100.0,
                                      height: 42.0,
                                      child: const Text(
                                        'Cancel',
                                        style: kButtonErrorStyle,
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: kBlue,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    elevation: 5.0,
                                    child: MaterialButton(
                                      onPressed: () {
                                        _register();
                                      },
                                      minWidth: 100.0,
                                      height: 42.0,
                                      child: const Text(
                                        'Create',
                                        style: kButtonTextStyle,
                                      ),
                                    ),
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/register');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      'current_user_role': _role,
      'username': selectedValue1! + selectedValue2!,
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
      'phone_number': _phoneNumberController.text,
      'balance': _balanceController.text,
      'created_by': _userId,
    });

    if (response.statusCode == 200) {
      print('Registration successful');
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Username already exists.'),
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
}
