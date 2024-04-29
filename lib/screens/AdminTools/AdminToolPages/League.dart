import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40.0),
                    labelText('League'),
                    textForm('Enter league you want to add'),
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
                                        Navigator.pop(context);
                                      },
                                      minWidth: 100.0,
                                      height: 42.0,
                                      child: const Text(
                                        'Add',
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
