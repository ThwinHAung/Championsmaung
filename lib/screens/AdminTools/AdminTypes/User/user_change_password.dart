import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';

class UserChangePassword extends StatefulWidget {
  static String id = 'user_change_password';
  const UserChangePassword({super.key});

  @override
  State<UserChangePassword> createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
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
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Old Password',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: kTextFieldActiveStyle,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter New Password',
                  ),
                ),
                const SizedBox(height: 5.0),
                TextFormField(
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
    );
  }
}
