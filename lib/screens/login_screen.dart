import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_home_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff252525),
      body: Container(
        color: kPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
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
                      hintText: 'Enter your email'),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration,
                  obscureText: true,
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
                        }),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: konPrimary,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(children: [
                  Expanded(
                    flex: 2,
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
                          onPressed: () {
                            _login();
                            //Implement registration functionality.
                          },
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
                ]),
              ]),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      final String role = responseData['role'];
      final String username = responseData['username'];

      // Handle token and role as needed
      const storage = FlutterSecureStorage();
      // if (_rememberMe) {
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'user_role', value: role);
      await storage.write(key: 'username', value: username);
      // storage.write(key: 'username', value: _usernameController.text),
      // storage.write(key: 'password', value: _passwordController.text),
      // } else {
      //   await Future.wait([
      //     storage.write(key: 'token', value: token),
      //     storage.write(key: 'user_role', value: role),
      //     storage.delete(key: 'username'),
      //     storage.delete(key: 'password'),
      //   ]);
      // }

      if (role == 'SSSenior') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SSSeniorAdminScreen()));
      } else if (role == 'User') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RulesPage()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SSeniorAdminScreen()));
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
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
//This is mine
