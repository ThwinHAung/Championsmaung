import 'dart:convert';
import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SSSeniorShowMembersList extends StatefulWidget {
  static const String id = "sssenior_show_members_list";
  const SSSeniorShowMembersList({super.key});

  @override
  State<SSSeniorShowMembersList> createState() => _SSSeniorShowMembersListState();
}

class _SSSeniorShowMembersListState extends State<SSSeniorShowMembersList>
    with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _memberList = [];
  List<String> _filteredData = [];

  final storage = const FlutterSecureStorage();
  String? _token;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _pageSize = 10;

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getToken();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          .where((item) =>
              item['username'].toString().toLowerCase().contains(query) ||
              item['realname'].toString().toLowerCase().contains(query))
          .map((item) => item['username'].toString())
          .toList();
      _currentPage = 1;
      _calculateTotalPages();
    });
  }

  Future<void> _fetchMemberList() async {
    var url = Uri.parse('${Config.apiUrl}/getmemberlist');
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
        _calculateTotalPages();
      });
    }
  }

  void _calculateTotalPages() {
    _totalPages = (_filteredData.length / _pageSize).ceil();
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the screen is desktop size (e.g., width >= 1200)
    final double screenWidth = MediaQuery.of(context).size.width;
    const double desktopBreakpoint = 1200; // Adjust this value as needed
    bool isDesktop = screenWidth >= desktopBreakpoint;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        // Main content
        Expanded(
          child: Scaffold(
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
          ),
        ),
      ],
    );
  }

  // Rest of your methods (view, _pageItems, ListCard) remain unchanged
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
                itemCount: _pageItems().length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> user = _memberList.firstWhere(
                    (element) => element['username'] == _pageItems()[index],
                    orElse: () => {},
                  );
                  return ListCard(
                      index + 1 + (_currentPage - 1) * _pageSize, user);
                }),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _totalPages,
              (index) => GestureDetector(
                onTap: () => _goToPage(index + 1),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index + 1 ? kBlue : kOnPrimaryContainer,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                        color: _currentPage == index + 1
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _pageItems() {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return _filteredData.sublist(startIndex,
        endIndex > _filteredData.length ? _filteredData.length : endIndex);
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
              child: const Icon(
                Icons.info_outline,
                color: kBlue,
                size: 20,
              ),
            ),
            onTap: () async {
              print(userData['id']);
              await Navigator.pushNamed(context, SSSeniorMemberDetails.id,
                  arguments: userData['id']);
            },
          ),
        ),
      ],
    );
  }

  // Helper methods
  Widget listTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget listText(String? text) {
    return Text(text ?? '');
  }
}