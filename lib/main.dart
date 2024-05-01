import 'package:champion_maung/Routes/UserRoutes/betting_history.dart';
import 'package:champion_maung/Routes/UserRoutes/body_betting.dart';
import 'package:champion_maung/Routes/UserRoutes/match_results.dart';
import 'package:champion_maung/Routes/UserRoutes/maung_betting.dart';
import 'package:champion_maung/Routes/UserRoutes/more.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/account.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/activity_log.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminToolPages/report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Master/master.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Master/master_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_match_view.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Senior/senior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Senior/senior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SeniorAgent/seniorAgent.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SeniorAgent/seniorAgent_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_home_screen.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:champion_maung/screens/registration_screen.dart';
import 'package:champion_maung/screens/splash_screen.dart';
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
        //SSSenior
        SSSeniorAdminScreen.id: (context) => const SSSeniorAdminScreen(),
        SSSeniorMembers.id: (context) => const SSSeniorMembers(),
        SSSeniorMatchView.id: (context) => const SSSeniorMatchView(),
        ActivityLogScreen.id: (context) => const ActivityLogScreen(),
        Report.id: (context) => const Report(),
        Deposit.id: (context) => const Deposit(),
        AccountSettings.id: (context) => const AccountSettings(),
        //SSenior
        SSeniorAdminScreen.id: (context) => const SSeniorAdminScreen(),
        SSeniorMembers.id: (context) => const SSeniorMembers(),
        //Senior
        SeniorAdminScreen.id: (context) => const SeniorAdminScreen(),
        SeniorMembers.id: (context) => const SeniorMembers(),
        //Master
        MasterAdminScreen.id: (context) => const MasterAdminScreen(),
        MasterMembers.id: (context) => const MasterMembers(),
        //SeniorAgent
        SeniorAgentAdminScreen.id: (context) => const SeniorAgentAdminScreen(),
        SeniorAgentMembers.id: (context) => const SeniorAgentMembers(),
        //Agent
        AgentAdminScreen.id: (context) => const AgentAdminScreen(),
        AgentMembers.id: (context) => const AgentMembers(),
        //User
        UserHomeScreen.id: (context) => const UserHomeScreen(),
      },
      home: const SplashScreen(),
    ); //hello
  }
}
