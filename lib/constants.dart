import 'package:flutter/material.dart';

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

const Color kPrimary = Color.fromARGB(255, 244, 245, 255);
const Color konPrimary = Color.fromARGB(255, 0, 0, 0);
const Color kOnPrimaryContainer = Color.fromARGB(255, 230, 230, 230);
const Color kSecondary = Color.fromARGB(255, 48, 48, 48);

const Color kError = Color(0xFFFD1F4A);

const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kGrey = Colors.grey;
const Color kBlue = Color(0xFF0D47A1);
const Color kGreen = Colors.green;

const kTextFieldHintStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
  color: konPrimary,
  letterSpacing: 2.0,
);

const kTextFieldActiveStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.bold,
  color: kSecondary,
);

const kButtonTextStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.bold,
  color: kPrimary,
);

const kButtonErrorStyle = TextStyle(
  fontSize: 10.0,
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
  fontSize: 10,
  fontWeight: FontWeight.w300,
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

Widget goalText(String goalText) {
  return Text(
    textAlign: TextAlign.center,
    goalText,
    style: kLabel,
  );
}

Widget bigCapText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: kBlue,
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

Widget secondaryMaterialButton(Color buttonColor, String buttonText,
    Color kButtonTextColor, VoidCallback onCustomButtonPressed) {
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
        style: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          color: kButtonTextColor,
        ),
      ),
    ),
  );
}

//username selection dropdown
const List<String> userDropdownItems = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
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

String? league_value;
String? team_value;
String? overUnder_calculate_value;
String? specialOdd_goals;
String? overUnder_goals;

List<Map<String, String>> leaguesDropdown = [
  {'name': 'Premiere League', 'value': '1'},
  {'name': 'Spain Laliga', 'value': '2'},
  {'name': 'Championship', 'value': '3'},
];

List<Map<String, String>> goalsDropdown = [
  {'name': '=', 'value': '0'},
  {'name': '1', 'value': '1'},
  {'name': '2', 'value': '2'},
  {'name': '3', 'value': '3'},
  {'name': '4', 'value': '4'},
  {'name': '5', 'value': '5'},
  {'name': '6', 'value': '6'},
  {'name': '7', 'value': '7'},
  {'name': '8', 'value': '8'},
  {'name': '9', 'value': '9'},
  {'name': '10', 'value': '10'},
];
List<Map<String, String>> OverUnderGoalsDropdown = [
  {'name': '1', 'value': '1'},
  {'name': '2', 'value': '2'},
  {'name': '3', 'value': '3'},
  {'name': '4', 'value': '4'},
  {'name': '5', 'value': '5'},
  {'name': '6', 'value': '6'},
  {'name': '7', 'value': '7'},
  {'name': '8', 'value': '8'},
  {'name': '9', 'value': '9'},
  {'name': '10', 'value': '10'},
];

List<Map<String, String>> specialOddTeam = [
  {'name': 'Home Team', 'value': 'H'},
  {'name': 'Away Team', 'value': 'A'},
];

List<Map<String, String>> calculatingSigns = [
  {'name': '-', 'value': '-'},
  {'name': '+', 'value': '+'},
];

Widget drawerListMenuText(text) {
  return Text(
    text,
    style: TextStyle(
      color: kBlue,
      fontSize: 12,
    ),
  );
}

Widget drawerListSubMenuText(text) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0),
    child: Text(
      text,
      style: TextStyle(
        color: kBlue,
        fontSize: 12,
      ),
    ),
  );
}

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
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Text(
      listText,
      style: const TextStyle(fontSize: 10.0),
    ),
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
              fontSize: 10,
              color: kBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    ),
  );
}

///LISTS for match views for both admin and user
List<String> leagues = ['Premiere League', 'Spain Laliga', 'Championship'];

List<List<String>> lists = [
  ['TeamOne 1', 'TeamTwo 1', 'Over 1', 'Under 1'],
  ['TeamOne 2', 'TeamTwo 2', 'Over 2', 'Under 2'],
  ['TeamOne 3', 'TeamTwo 3', 'Over 3', 'Under 3'],
];

List<String> specialOddHomeTeam = [];
List<String> specialOddAwayTeam = [];

List<String> specialOddFirstDigit = [];
List<String> specialOddSign = [];
List<String> specialOddLastDigit = ['60', '40', '15'];

List<String> overUnderFirstDigit = ['1', '3', '4'];
List<String> overUnderSign = [];
List<String> overunderLastDigit = ['60', '70', '10'];

Widget showUsername(String username) {
  return Text(
    'Username : $username',
    style: const TextStyle(
      color: kBlue,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget showAccountType(String role) {
  return Text(
    'Your account type : $role',
    style: const TextStyle(
      color: kBlue,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget detailsListTitleText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: kBlue,
      fontSize: 12,
    ),
  );
}

Widget detailsListText(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 10),
  );
}
