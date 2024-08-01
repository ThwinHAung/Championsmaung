import 'dart:convert';

import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LeagueScreen extends StatefulWidget {
  static const id = "input_LeagueScreen";
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  final TextEditingController _leagueNameController = TextEditingController();
  final storage = const FlutterSecureStorage();
  String? _token;
  @override
  void initState() {
    _getToken();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data or perform necessary actions
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  Future<void> _insertLeague() async {
    final response = await http.post(Uri.parse('${Config.apiUrl}/addingleague'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'name': _leagueNameController.text,
        }));
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text('Adding League Succeed!'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      })),
                ],
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Failed"),
            content: const Text('Adding League Failed!'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      })),
                ],
              )
            ],
          );
        },
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
          'Add League',
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
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelText('League'),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _leagueNameController,
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter league you want to add'),
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
                                  'Do you want to add league?',
                                  style: kLabel,
                                ),
                                actions: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: materialButton(kError, 'Cancel',
                                            () {
                                          Navigator.pop(context);
                                        }),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Expanded(
                                        flex: 1,
                                        child: materialButton(
                                            kBlue, 'Enter', _insertLeague),
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
                            'Add League',
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
}
