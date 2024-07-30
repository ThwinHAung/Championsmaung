import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SSSeniorShowMembersList extends StatefulWidget {
  static String id = "sssenior_show_members_list";
  const SSSeniorShowMembersList({super.key});

  @override
  State<SSSeniorShowMembersList> createState() =>
      _SSSeniorShowMembersListState();
}

class _SSSeniorShowMembersListState extends State<SSSeniorShowMembersList> {
  final TextEditingController _unitReduceController = TextEditingController();
  final TextEditingController _unitAddController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _memberList = [];
  List<String> _filteredData = [];
  final storage = const FlutterSecureStorage();
  String? _token;

  @override
  void initState() {
    _getToken();
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      await _fetchMemberList();
    }
  }

  void _onSearchChanged() {
    String query = _controller.text.toLowerCase();
    setState(() {
      _filteredData = _memberList
          .map((item) => item['username'].toString())
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _fetchMemberList() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/getmemberlist');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _memberList = jsonDecode(response.body)['created_users'];
        _filteredData =
            _memberList.map((item) => item['username'].toString()).toList();
      });
    } else {
      print('xx');
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
          'Members List',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        color: kPrimary,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                color: kOnPrimaryContainer,
                borderRadius: BorderRadius.circular(10)),
            child: view(),
          ),
        ),
      ),
    );
  }

  Widget view() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: listTitleText('No.'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Name'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Username'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Balance'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Details'),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> user = _memberList.firstWhere(
                    (element) => element['username'] == _filteredData[index],
                    orElse: () => {},
                  );
                  return ListCard(index + 1, user);
                }),
          ),
        ],
      ),
    );
  }

  Widget ListCard(int index, Map<String, dynamic> userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: listText(index.toString()),
        ),
        Expanded(
          flex: 5,
          child: listText(userData['realname']),
        ),
        Expanded(
          flex: 5,
          child: listText(userData['username']),
        ),
        Expanded(
          flex: 5,
          child: listText(
            userData['balance'].toString(),
          ),
        ),
        Expanded(
          flex: 5,
          child: GestureDetector(
            child: Container(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.info_outline,
                color: kBlue,
                size: 20,
              ),
            ),
            onTap: () async {
              await Navigator.pushNamed(context, SSSeniorMemberDetails.id,
                  arguments: userData['id']);
              _fetchMemberList();
            },
          ),
        ),
      ],
    );
  }

  // Methods for reducing units, adding units, setting PP, unsetting PP, and deleting user remain unchanged.
  // ...
}
