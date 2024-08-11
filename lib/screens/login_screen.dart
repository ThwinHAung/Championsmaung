import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _passwordObsecureText = true;

  @override
  void initState() {
    super.initState();
    _checkRememberedUser();
  }

  Future<void> _checkRememberedUser() async {
    if (kIsWeb) {
      const storage = FlutterSecureStorage();
      final String? username = await storage.read(key: 'username');
      final String? password = await storage.read(key: 'password');
      if (username != null && password != null) {
        setState(() {
          _usernameController.text = username;
          _passwordController.text = password;
          _rememberMe = true;
        });
      }
    } else {
      const storage = FlutterSecureStorage();
      final String? username = await storage.read(key: 'username');
      final String? password = await storage.read(key: 'password');
      if (username != null && password != null) {
        setState(() {
          _usernameController.text = username;
          _passwordController.text = password;
          _rememberMe = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation
        return false;
      },
      child: Scaffold(
        backgroundColor: kPrimary,
        body: Container(
          color: kPrimary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'championmaung',
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: const Text(
                      'CHAMPION MAUNG',
                      style: TextStyle(
                        color: konPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _usernameController,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your username',
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _passwordObsecureText,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordObsecureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordObsecureText = !_passwordObsecureText;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    const Text(
                      'Remember Me',
                      style: TextStyle(
                        color: konPrimary,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: kBlue,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          elevation: 5.0,
                          child: MaterialButton(
                            onPressed: _isLoading ? null : _login,
                            minWidth: 200.0,
                            height: 42.0,
                            child: const Text(
                              'Login',
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_isLoading) return;

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Username and password cannot be empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: kBlue,
              ),
              SizedBox(height: 20.0),
              Text(
                'Loading...',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 14,
                  color: kOnPrimaryContainer,
                ),
              ),
            ],
          ),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/login'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      // Dismiss loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];
        final String role = responseData['role'];
        final String username = responseData['username'];

        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: token);
        await storage.write(key: 'user_role', value: role);
        await storage.write(key: 'user_name', value: username);

        if (_rememberMe) {
          await storage.write(key: 'username', value: _usernameController.text);
          await storage.write(key: 'password', value: _passwordController.text);
        } else {
          await storage.delete(key: 'username');
          await storage.delete(key: 'password');
        }

        // Redirect based on user role
        if (role == 'SSSenior') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SSSeniorAdminScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (role == 'User') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const RulesPage(),
            ),
            (Route<dynamic> route) => false,
          );
        } else if (role == 'SSenior' || role == 'Senior' || role == 'Master') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SSeniorAdminScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AgentAdminScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        final responseData = json.decode(response.body);
        final message = responseData['message'];
        _showErrorDialog(message);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Dismiss loading dialog
      Navigator.of(context).pop();

      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                flex: 1,
                child: materialButton(kBlue, 'OK', () {
                  setState(() {
                    Navigator.pop(context);
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
