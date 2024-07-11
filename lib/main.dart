import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/League.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/account.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/activity_log.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/deposit.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/AdminToolPages/report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_inputs.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_match_history.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_match_view.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_members.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_show_members_list.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSenior/ssenior_show_members_list.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting/body_betting.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting/maung_betting.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history/body_bet_history_matches.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/betting_history/maung_bet_history_matches.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/match_results.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/more.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page_for_route.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_change_password.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_home_screen.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:champion_maung/screens/my_loading.dart';
import 'package:champion_maung/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ChampionMaung());

class ChampionMaung extends StatelessWidget {
  const ChampionMaung({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'TimesNewRoman',
            ),
        primaryTextTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'TimesNewRoman',
            ),
      ),
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        MyLoading.id: (context) => const MyLoading(),

        //SSSenior
        SSSeniorAdminScreen.id: (context) => const SSSeniorAdminScreen(),
        SSSeniorMembers.id: (context) => const SSSeniorMembers(),
        SSSeniorInputsPage.id: (context) => const SSSeniorInputsPage(),
        SSSeniorMatchView.id: (context) => const SSSeniorMatchView(),
        SSSeniorMatchHistory.id: (context) => const SSSeniorMatchHistory(),
        SSSeniorShowMembersList.id: (context) =>
            const SSSeniorShowMembersList(),
        SSSeniorMemberDetails.id: (context) => const SSSeniorMemberDetails(),
        ActivityLogScreen.id: (context) => const ActivityLogScreen(),
        Report.id: (context) => const Report(),
        Deposit.id: (context) => const Deposit(),
        LeagueScreen.id: (context) => const LeagueScreen(),
        AccountSettings.id: (context) => const AccountSettings(),
        //SSenior
        SSeniorAdminScreen.id: (context) => const SSeniorAdminScreen(),
        SSeniorMembers.id: (context) => const SSeniorMembers(),
        SSeniorShowMembersList.id: (context) => const SSeniorShowMembersList(),
        //User
        RulesPage.id: (context) => const RulesPage(),
        RulesPageForRoute.id: (context) => const RulesPageForRoute(),
        UserHomeScreen.id: (context) => const UserHomeScreen(),
        BodyBetting.id: (context) => const BodyBetting(),
        MaungBetting.id: (context) => const MaungBetting(),
        MatchResults.id: (context) => const MatchResults(),
        BettingHistory.id: (context) => const BettingHistory(),
        BodyBetHistoryMatches.id: (context) => const BodyBetHistoryMatches(),
        MaungBetHistoryMatches.id: (context) => const MaungBetHistoryMatches(),
        UserChangePassword.id: (context) => const UserChangePassword(),
        More.id: (context) => const More(),
      },
      home: const SplashScreen(),
    ); //hello
  }
}
