import 'dart:convert';

import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_member_details.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AgentShowMembersList extends StatefulWidget {
  static String id = "agent_show_members_list";
  const AgentShowMembersList({super.key});

  @override
  State<AgentShowMembersList> createState() => _AgentShowMembersListState();
}

class _AgentShowMembersListState extends State<AgentShowMembersList> {
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
    // Refresh data or perform necessary actions
    _getToken();
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
            padding: const EdgeInsets.fromLTRB(15.0, 8.0, 8.0, 8.0),
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
            onTap: () {
              Navigator.pushNamed(context, AgentMemberDetails.id,
                  arguments: userData['id']);
            },
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
      // Clear the controller
      _unitAddController.clear();

      // Refresh the member list
      await _fetchMemberList();

      // Close the previous dialog
      Navigator.pop(context);
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Units have been successfully reduced.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failed'),
            content: const Text('Failed to reduce units.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
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
      // Clear the controller
      _unitAddController.clear();

      // Refresh the member list
      await _fetchMemberList();

      // Close the previous dialog
      Navigator.pop(context);
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Units have been successfully added.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failed'),
            content: const Text('Failed to add units.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _setPP(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/postpone_user');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
    });
    if (response.statusCode == 200) {
      // Refresh the member list
      await _fetchMemberList();

      // Close the previous dialog
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Postponed this user.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failed'),
            content: const Text('Failed to postpone this user'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _unsetPP(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/unpostpone_user');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
    });
    if (response.statusCode == 200) {
      // Refresh the member list
      await _fetchMemberList();

      // Close the previous dialog
      Navigator.pop(context);
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('This user has been unpostponed'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failed'),
            content: const Text('Failed to unpostpone this user'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _delete(String userId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/delete_user');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $_token',
    }, body: {
      "user_id": userId,
    });
    if (response.statusCode == 200) {
      // Refresh the member list
      await _fetchMemberList();

      // Close the previous dialog
      Navigator.pop(context);
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('This user has been deleted.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Failed'),
            content: const Text('Failed to delete this user.'),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      flex: 1,
                      child: materialButton(kBlue, 'OK', () {
                        Navigator.pop(context);
                      }))
                ],
              ),
            ],
          );
        },
      );
    }
  }
}
