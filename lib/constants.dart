import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const Color kPrimary = Color.fromARGB(255, 210, 210, 210);
const Color konPrimary = Color.fromARGB(255, 0, 0, 0);
const Color kOnPrimaryContainer = Color.fromARGB(255, 230, 230, 230);
const Color kSecondary = Color.fromARGB(255, 48, 48, 48);

const Color kError = Color(0xFFFD1F4A);

const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kGrey = Colors.grey;
const Color kBlue = Color(0xFF0D47A1);

const kTextFieldHintStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  color: konPrimary,
  letterSpacing: 2.0,
);

const kTextFieldActiveStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
  color: kSecondary,
);

const kButtonTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
  color: kPrimary,
);

const kButtonErrorStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
  color: kError,
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kOnPrimaryContainer,
  hintText: 'Enter your password.',
  focusColor: konPrimary,
  hintStyle: kTextFieldHintStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kOnPrimaryContainer, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kOnPrimaryContainer, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

const kLabel = TextStyle(
  color: konPrimary,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

Widget labelText(String labelText) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: Text(
      labelText,
      style: kLabel,
    ),
  );
}

Widget textForm(String textItem) {
  return TextFormField(
    style: kTextFieldActiveStyle,
    decoration: kTextFieldDecoration.copyWith(hintText: textItem),
  );
}

Widget passwordForm(String passwordItem) {
  return TextFormField(
    style: kTextFieldActiveStyle,
    decoration: kTextFieldDecoration.copyWith(hintText: passwordItem),
    obscureText: true,
  );
}

Widget materialButton(
    Color buttonColor, String buttonText, VoidCallback onCustomButtonPressed) {
  return Material(
    color: buttonColor,
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    elevation: 5.0,
    child: MaterialButton(
      onPressed: onCustomButtonPressed,
      minWidth: 200.0,
      height: 42.0,
      child: Text(
        buttonText,
        style: kButtonTextStyle,
      ),
    ),
  );
}

//username selection dropdown
const List<String> userDropdownItems = [
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

Widget listTitleText(String listTitleText) {
  return Text(
    listTitleText,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      color: kBlue,
    ),
  );
}

Widget listText(String listText) {
  return Text(
    listText,
    style: const TextStyle(fontSize: 10.0),
  );
}

Widget rulesText(String cap, String text) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Text(
            cap,
            style: const TextStyle(
              fontSize: 15,
              color: kBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 5, 15, 0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: kGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    ),
  );
}
