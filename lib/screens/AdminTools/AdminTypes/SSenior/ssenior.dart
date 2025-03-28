import 'package:champion_maung/config.dart';
import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/Master/master_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/SSenior/ssenior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/Senior/senior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_dashboard.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_notifications.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_show_members_list.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SSeniorAdminScreen extends StatefulWidget {
  static const String id = 'ssenior_admin_screen';
  const SSeniorAdminScreen({super.key});

  @override
  State<SSeniorAdminScreen> createState() => _SSeniorAdminScreenState();
}

class _SSeniorAdminScreenState extends State<SSeniorAdminScreen>
    with WidgetsBindingObserver {
  final storage = const FlutterSecureStorage();
  String? _token;
  String? _role;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDisposed = false; // Flag to track if the widget is disposed

  @override
  void initState() {
    _role = 'Loading...';
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getToken(); // Fetch token when dependencies change
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _getToken(); // Fetch token when app resumes
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isDisposed = true; // Mark the widget as disposed
    super.dispose();
  }

  Future<void> _getToken() async {
    _token = await storage.read(key: 'token');
    final String? role = await storage.read(key: 'user_role');
    if (role != null) {
      setState(() {
        _role = role;
      });
    }
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (MediaQuery.of(context).size.width < 600) {
      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
        Navigator.of(context).pop(); // Close the drawer immediately
      }
    }

    // if (MediaQuery.of(context).size.width < 600) {
    //   // Close the drawer after a short delay to ensure the widget is updated first
    //   Future.delayed(Duration(milliseconds: 200), () {
    //     if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
    //       Navigator.of(context).pop(); // Close the drawer
    //     }
    //   });
    // }
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
        _buildIconTile(Icons.notifications, 'Notifications', 4),
        ListTile(
        leading: const Icon(Icons.language),
        title: drawerListMenuText('Change Language'),
        onTap: () {
          // Show the dialog to change the language
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
      const SSeniorMembers(),
      const SSeniorShowMembersList(),
      _role == 'SSenior'
          ? const SSeniorDailyReport()
          : _role == 'Senior'
              ? const SeniorDailyReport() // Replace with the correct widget for Senior
              : _role == 'Master'
                  ? const MasterDailyReport() // Replace with the correct widget for Master
                  : const Center(
                      child: Text(
                        'Unauthorized Role',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ), // here this route for condition
      const SSeniorNotifications(),

    ];

    // final List<Widget> _widgets = [
    //   SSSeniorDashboard(),
    //   SSeniorMembers(),
    //   SSeniorShowMembersList(),
    //   _role == 'SSenior'
    //       ? SSeniorDailyReport() // Route for SSenior role
    //       : _role == 'Senior'
    //           ? SeniorDailyReport() // Replace with the actual widget for Senior
    //           : _role == 'Master'
    //               ? MasterDailyReport() // Replace with the actual widget for Master
    //               : Center(
    //                   child: Text('Role not recognized')), // Fallback widget
    // ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: Text(
          'CHAMPION MAUNG ($_role)',
          style: const TextStyle(
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
