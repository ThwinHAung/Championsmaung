import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimary,
      body: Padding(
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
            const SizedBox(height: 20.0),
            TextFormField(
              style: const TextStyle(color: konPrimary),
              controller: _usernameController,
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter Username'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _passwordController,
              style: const TextStyle(color: konPrimary),
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter Password'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: kBlue,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () {
                          _register(); //Implement registration functionality.
                        },
                        minWidth: 200.0,
                        height: 42.0,
                        child: const Text(
                          'Register',
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
    );
  }

  Future<void> _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var url = Uri.parse(
        'https://10.0.2.2:3000/flutter_api/controller/register_controller.php');
    var response = await http
        .post(url, body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      print('Registration successful');
    } else {
      print('Registration failed');
    }
  }
}
