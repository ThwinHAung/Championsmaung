import 'package:champion_maung/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class Members extends StatefulWidget {
  static String id = 'member_page';
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final List<String> items = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  String? selectedValue;

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
                        'Your account type : ' + 'SSSenior',
                        style: TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'View Member List',
                      style: TextStyle(
                        color: kPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: DropdownButtonHideUnderline(
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
                            items: items
                                .map((String item) => DropdownMenuItem<String>(
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
                            value: selectedValue,
                            onChanged: (String? value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
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
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Phone Number',
                        style: kLabel,
                      ),
                    ),
                    TextFormField(
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your phone number'),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Password',
                        style: kLabel,
                      ),
                    ),
                    TextFormField(
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter password'),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Starting Balance',
                        style: kLabel,
                      ),
                    ),
                    TextFormField(
                      style: kTextFieldActiveStyle,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Balance'),
                    ),
                    SizedBox(height: 30.0),
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
                                    color: kBlue,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    elevation: 5.0,
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      minWidth: 200.0,
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
}
