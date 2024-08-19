import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_dashboard.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_master_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SSSeniorAdminScreen extends StatefulWidget {
  static const String id = 'sssenior_admin_screen';
  const SSSeniorAdminScreen({super.key});

  @override
  State<SSSeniorAdminScreen> createState() => _SSSeniorAdminScreenState();
}

class _SSSeniorAdminScreenState extends State<SSSeniorAdminScreen> {
  final storage = const FlutterSecureStorage();
  String? _token;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (MediaQuery.of(context).size.width < 600) {
      Navigator.of(context)
          .pop(); // Close the drawer when an item is selected on small screens
    }
  }

  Future<void> _logout() async {
    var url = Uri.parse('${Config.apiUrl}/logout');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'role');
      await storage.delete(key: 'user_name');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print(response.body);
    }
  }

  Widget _buildDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(height: 30.0),
        _buildListTile('Dashboard', 0),
        _buildExpansionTile(
          'Members Management',
          [
            _buildListTile('Create Member', 1),
            _buildListTile('Members List', 2),
          ],
          [1, 2],
        ),
        _buildExpansionTile(
          'Report',
          [
            _buildListTile('Daily', 3),
            _buildListTile('Master', 4),
          ],
          [3, 4],
        ),
        ListTile(
          title: drawerListMenuText('Log Out'),
          onTap: () {
            _logout();
          },
        ),
      ],
    );
  }

  Widget _buildListTile(String title, int index) {
    return ListTile(
      tileColor: _selectedIndex == index ? kOnPrimaryContainer : null,
      title: drawerListMenuText(title),
      onTap: () {
        _onItemSelected(index);
      },
    );
  }

  Widget _buildExpansionTile(
      String title, List<Widget> children, List<int> expandedIndices) {
    return ExpansionTile(
      initiallyExpanded: expandedIndices.contains(_selectedIndex),
      title: drawerListMenuText(title),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    // List of widgets to display on the right side
    final List<Widget> _widgets = [
      SSSeniorDashboard(),
      SSSeniorMembers(),
      SSSeniorShowMembersList(),
      SSSeniorDailyReport(),
      SSSeniorMasterReport(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'CHAMPION MAUNG (SSSenior)',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        leading: w < 600
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
      ),
      drawer: w < 600 ? Drawer(child: _buildDrawer()) : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _widgets[_selectedIndex];
          } else {
            return Row(
              children: [
                Container(
                  width: w * 0.15, // Adjust the width as needed
                  color: kOnPrimaryContainer,
                  child: _buildDrawer(),
                ),
                Expanded(
                  child: _widgets[_selectedIndex],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
