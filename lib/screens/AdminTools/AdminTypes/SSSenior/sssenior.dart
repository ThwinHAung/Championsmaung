import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/SSSenior/sssenior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_dashboard.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_match_view.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_notifications.dart';
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

class _SSSeniorAdminScreenState extends State<SSSeniorAdminScreen>
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
      Future.delayed(const Duration(milliseconds: 200), () {
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
    } else {}
  }

  Widget _buildDrawer() {
  return ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      const SizedBox(height: 30.0),
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
        Icons.settings,
        'Matches Management',
        [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildIconTile(Icons.access_alarm, 'View Matches', 3),
          )
        ],
        [3],
      ),
      _buildExpansionTile(
        Icons.report,
        'Report',
        [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildIconTile(Icons.calendar_today, 'Daily', 4),
          ),
        ],
        [4],
      ),
      _buildIconTile(Icons.notifications, 'Notifications', 5),
      ListTile(
        leading: const Icon(Icons.language),
        title: drawerListMenuText('Change Language'),
        onTap: () {
          // Handle language change functionality here
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Change Language'),
              content: const Text('Select your preferred language.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: drawerListMenuText('Log Out'),
        onTap: () {
          _logout();
        },
      ),
    ],
  );
}

Widget _buildSmallDrawer() {
  return ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      const SizedBox(height: 30.0),
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
        Icons.settings,
        '',
        [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildIconTile(Icons.access_alarm, '', 3),
          )
        ],
        [3],
      ),
      _buildExpansionTile(
        Icons.report,
        '',
        [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: _buildIconTile(Icons.calendar_today, '', 4),
          ),
        ],
        [4],
      ),
      _buildIconTile(Icons.notifications, '', 5),
      ListTile(
        leading: const Icon(Icons.language),
        title: drawerListMenuText(''),
        onTap: () {
          // Handle language change functionality here
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Change Language'),
              content: const Text('Select your preferred language.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: drawerListMenuText(''),
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
    final List<Widget> widgets = [
      const SSSeniorDashboard(),
      const SSSeniorMembers(),
      const SSSeniorShowMembersList(),
      const SSSeniorMatchView(),
      const SSSeniorDailyReport(),
      const SSSeniorNotifications(),
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
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1200) {
            return Row(
              children: [
                Container(
                  width: w * 0.20, // Adjust the width as needed
                  color: kPrimary,
                  child: _buildSmallDrawer(),
                ),
                const VerticalDivider(),
                Expanded(
                  child: widgets[_selectedIndex],
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
                const VerticalDivider(),
                Expanded(
                  child: widgets[_selectedIndex],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
