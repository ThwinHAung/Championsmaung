import 'package:champion_maung/Routes/betting_history.dart';
import 'package:champion_maung/Routes/body_betting.dart';
import 'package:champion_maung/Routes/match_results.dart';
import 'package:champion_maung/Routes/maung_betting.dart';
import 'package:champion_maung/Routes/more.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/create_user.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/user_accounts.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/user_list.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/user_report.dart';
import 'package:champion_maung/screens/AdminTools/admin_screen.dart';
import 'package:champion_maung/screens/agent_screen.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:champion_maung/screens/registration_screen.dart';
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
        CreateUser.id: (context) => const CreateUser(),
        UserList.id: (context) => const UserList(),
        UserReport.id: (context) => const UserReport(),
        UserDeposit.id: (context) => const UserDeposit(),
        UserAccounts.id: (context) => const UserAccounts(),
      },
      home: const RegistrationScreen(),
    ); //hello
  }
}
