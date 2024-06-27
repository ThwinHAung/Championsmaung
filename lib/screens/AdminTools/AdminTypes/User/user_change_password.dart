import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserChangePassword extends StatefulWidget {
  static String id = 'user_change_password';
  const UserChangePassword({super.key});

  @override
  State<UserChangePassword> createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  final storage = const FlutterSecureStorage();
  String? _token;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  Future<void> _passwordChange() async {
    var url = Uri.parse('https://championmaung.com/api/change_password');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: {
        'current_password': _confirmPasswordController.text,
        'new_password': _newPasswordController.text,
        'new_password_confirmation': _confirmPasswordController.text,
      },
    );
    if (response.statusCode == 200) {
      print('okay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kPrimary,
        appBar: AppBar(
          backgroundColor: kPrimary,
          centerTitle: true,
          title: const Text(
            'Change Password',
            style: TextStyle(
              color: konPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: kPrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText('Change your password'),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _currentPasswordController,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Current Password',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _newPasswordController,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter New Password',
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    style: kTextFieldActiveStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Confirm New Password',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Expanded(
                        child: materialButton(
                          kBlue,
                          'Change Password',
                          () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Change Password'),
                                content: const Text(
                                    'Do you really want to change password?'),
                                actions: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: materialButton(
                                          kError,
                                          'Cancel',
                                          () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        flex: 1,
                                        child: materialButton(
                                          kBlue,
                                          'Enter',
                                          () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
