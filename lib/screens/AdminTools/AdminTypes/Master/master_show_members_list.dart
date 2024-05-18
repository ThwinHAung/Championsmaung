import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MasterShowMembersList extends StatefulWidget {
  static String id = "master_show_members_list";
  const MasterShowMembersList({super.key});

  @override
  State<MasterShowMembersList> createState() => _MasterShowMembersList();
}

class _MasterShowMembersList extends State<MasterShowMembersList> {
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

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    if (_token != null) {
      _fetchMemberList();
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                // labelText: 'Search',
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: listTitleText('ID'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Username'),
              ),
              Expanded(
                flex: 5,
                child: listTitleText('Phone Number'),
              ),
              Expanded(
                flex: 3,
                child: listTitleText('Units'),
              ),
              Expanded(
                flex: 7,
                child: listTitleText('Add/Reduce units'),
              ),
              Expanded(
                flex: 7,
                child: listTitleText('Delete/Postpone'),
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
    String userId = userData['id'].toString();
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: listText(index.toString()),
        ),
        Expanded(
          flex: 5,
          child: listText(userData['username']),
        ),
        Expanded(
          flex: 5,
          child: listText(userData['phone_number']),
        ),
        Expanded(flex: 3, child: listText(userData['balance'].toString())),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reduce Unit'),
                      content:
                          const Text('Enter the amount of unit to reduce.'),
                      actions: <Widget>[
                        TextFormField(
                          controller: _unitReduceController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter unit amount'),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Reduce Unit'),
                                content: const Text(
                                    'Do you really want to reduce "replace unit here" units from this account?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      _reduceUnits(userId);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: kError),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print(userId);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Enter'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  fixedSize: const Size(5, 5),
                ),
                child: const Text(
                  '-',
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Add Unit'),
                      content: const Text('Enter the amount of unit to add.'),
                      actions: <Widget>[
                        TextFormField(
                          controller: _unitAddController,
                          style: kTextFieldActiveStyle,
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter unit amount'),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Add Unit'),
                                content: const Text(
                                    'Do you really want to add "replace unit here" units from this account?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: kError),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _addUnits(userId);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Enter'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  fixedSize: const Size(5, 5),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(
                    color: kBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Account'),
                      content:
                          const Text('Do you really want delete this account?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: kError),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _delete(userId);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    fixedSize: const Size(5, 5), iconColor: kError),
                child: const Icon(Icons.delete_outline_outlined),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Postpone Account'),
                      content: const Text(
                          'Do you really want to postpone this account?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: kError),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _setPP(userId);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    fixedSize: const Size(5, 5), iconColor: kError),
                child: const Icon(Icons.error_outline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _reduceUnits(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/reducing_units');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
      "amount": _unitReduceController.text,
    });
    if (response.statusCode == 200) {
      print('ok');
    }
  }

  Future<void> _addUnits(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/adding_units');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
      "amount": _unitAddController.text,
    });
    if (response.statusCode == 200) {
      print('ok');
    }
  }

  Future<void> _setPP(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/postpone_user');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
    });
    if (response.statusCode == 200) {}
  }

  Future<void> _unsetPP(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/unpostpone_user');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
    });
    if (response.statusCode == 200) {}
  }

  Future<void> _delete(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/delete_user');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
    });
    if (response.statusCode == 200) {}
  }
}
