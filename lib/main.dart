import 'package:champion_maung/Routes/UserRoutes/betting_history.dart';
import 'package:champion_maung/Routes/UserRoutes/body_betting.dart';
import 'package:champion_maung/Routes/UserRoutes/match_results.dart';
import 'package:champion_maung/Routes/UserRoutes/maung_betting.dart';
import 'package:champion_maung/Routes/UserRoutes/more.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/activity_log.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/members.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/report.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/account.dart';
import 'package:champion_maung/screens/AdminTools/admin_screen.dart';
import 'package:champion_maung/screens/agent_screen.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:champion_maung/screens/registration_screen.dart';
import 'package:champion_maung/screens/splash_screen.dart';
import 'package:champion_maung/screens/user_home_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ChampionMaung());

class ChampionMaung extends StatelessWidget {
  const ChampionMaung({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        UserHomeScreen.id: (context) => const UserHomeScreen(),
        BodyBetting.id: (context) => const BodyBetting(),
        MaungBetting.id: (context) => const MaungBetting(),
        MatchResults.id: (context) => const MatchResults(),
        BettingHistory.id: (context) => const BettingHistory(),
        More.id: (context) => const More(),
        AgentScreen.id: (context) => const AgentScreen(),
        AdminScreen.id: (context) => const AdminScreen(),
        ActivityLogScreen.id: (context) => const ActivityLogScreen(),
        Members.id: (context) => const Members(),
        Report.id: (context) => const Report(),
        Deposit.id: (context) => const Deposit(),
        AccountSettings.id: (context) => const AccountSettings(),
      },
      home: const SplashScreen(),
    ); //hello
  }
}
