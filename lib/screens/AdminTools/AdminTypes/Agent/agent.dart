import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/Agent/agent_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_dashboard.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_show_members_list.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AgentAdminScreen extends StatefulWidget {
  static const String id = 'agent_admin_screen';
  const AgentAdminScreen({super.key});

  @override
  State<AgentAdminScreen> createState() => _AgentAdminScreenState();
}

class _AgentAdminScreenState extends State<AgentAdminScreen>
    with WidgetsBindingObserver {
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
      // Close the drawer after a short delay to ensure the widget is updated first
      Future.delayed(Duration(milliseconds: 200), () {
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          Navigator.of(context).pop(); // Close the drawer
        }
      });
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

  Widget _buildSmallDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(height: 30.0),
        _buildIconTile(Icons.dashboard, '', 0),
        _buildExpansionTile(
          Icons.people,
          '',
          [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildIconTile(Icons.add, '', 1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildIconTile(Icons.list, '', 2),
            ),
          ],
          [1, 2],
        ),
        _buildExpansionTile(
          Icons.report,
          '',
          [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildIconTile(Icons.calendar_today, '', 3),
            ),
          ],
          [3],
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: drawerListMenuText(''),
          onTap: () {
            _logout();
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        SizedBox(height: 30.0),
        _buildIconTile(Icons.dashboard, 'Dashboard', 0),
        _buildExpansionTile(
          Icons.people,
          'Members Management',
          [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildIconTile(Icons.add, 'Create Member', 1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildIconTile(Icons.list, 'Members List', 2),
            ),
          ],
          [1, 2],
        ),
        _buildExpansionTile(
          Icons.report,
          'Report',
          [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildIconTile(Icons.calendar_today, 'Daily', 3),
            ),
          ],
          [3],
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: drawerListMenuText('Log Out'),
          onTap: () {
            _logout();
          },
        ),
      ],
    );
  }

  Widget _buildIconTile(IconData icon, String title, int index) {
    return ListTile(
      leading:
          Icon(icon, size: 20, color: _selectedIndex == index ? kBlue : null),
      tileColor: _selectedIndex == index ? kOnPrimaryContainer : null,
      title: drawerListMenuText(title),
      onTap: () {
        _onItemSelected(index);
      },
    );
  }

  Widget _buildExpansionTile(IconData icon, String title, List<Widget> children,
      List<int> expandedIndices) {
    return ExpansionTile(
      leading: Icon(icon,
          size: 20, color: _selectedIndex == expandedIndices[0] ? kBlue : null),
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
      AgentMembers(),
      SSeniorShowMembersList(),
      AgentDailyReport(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'CHAMPION MAUNG (Agent)',
          style: TextStyle(
            color: konPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Row(
              children: [
                Container(
                  width: w * 0.20, // Adjust the width as needed
                  color: kPrimary,
                  child: _buildSmallDrawer(),
                ),
                VerticalDivider(),
                Expanded(
                  child: _widgets[_selectedIndex],
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Container(
                  width: w * 0.15, // Adjust the width as needed
                  color: kPrimary,
                  child: _buildDrawer(),
                ),
                VerticalDivider(),
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
