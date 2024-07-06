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

  bool _currentPasswordObsecureText = true;
  bool _newPasswordObsecureText = true;
  bool _confirmNewPasswordObsecureText = true;

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
    var url = Uri.parse('https://www.championmaung.com/api/change_password');
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
    return Scaffold(
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
                  obscureText: _currentPasswordObsecureText,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Current password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _currentPasswordObsecureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPasswordObsecureText =
                              !_currentPasswordObsecureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _newPasswordObsecureText,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter New password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newPasswordObsecureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _newPasswordObsecureText = !_newPasswordObsecureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _confirmNewPasswordObsecureText,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Confirm New password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmNewPasswordObsecureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmNewPasswordObsecureText =
                              !_confirmNewPasswordObsecureText;
                        });
                      },
                    ),
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
    );
  }
}
