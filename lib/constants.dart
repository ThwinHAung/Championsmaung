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

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kOnPrimaryContainer,
  hintText: 'Enter your password.',
  focusColor: konPrimary,
  hintStyle: kTextFieldHintStyle,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kOnPrimaryContainer, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kOnPrimaryContainer, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  ),
);
