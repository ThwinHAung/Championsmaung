import 'package:champion_maung/constants.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Agent/agent_member.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/agent_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/master_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/senior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/ssenior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/sssenior_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/Reports/user_daily_report.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/SSSenior/sssenior_member_details_transcations_actionpage.dart';
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
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/pending_matches.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/rules_page_for_route.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/User/user_home_screen.dart';
import 'package:champion_maung/screens/AdminTools/AdminTypes/change_password_self.dart';
import 'package:champion_maung/screens/login_screen.dart';
import 'package:champion_maung/screens/my_loading.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ChampionMaung());

class ChampionMaung extends StatelessWidget with WidgetsBindingObserver {
  const ChampionMaung({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: kBlue,
        brightness: Brightness.light,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'SF-Pro',
            ),
        primaryTextTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'SF-Pro',
            ),
      ),
      onGenerateRoute: (settings) {
        // Define your route transitions here
        switch (settings.name) {
          case LoginScreen.id:
            return _buildSlideTransition(
              page: const LoginScreen(),
              settings: settings,
            );
          case MyLoading.id:
            return _buildSlideTransition(
              page: const MyLoading(),
              settings: settings,
            );
          case ChangePasswordSelf.id:
            return _buildSlideTransition(
              page: const ChangePasswordSelf(),
              settings: settings,
            );
          case SSSeniorAdminScreen.id:
            return _buildSlideTransition(
              page: const SSSeniorAdminScreen(),
              settings: settings,
            );
          case SSSeniorMembers.id:
            return _buildSlideTransition(
              page: const SSSeniorMembers(),
              settings: settings,
            );
          case SSSeniorShowMembersList.id:
            return _buildSlideTransition(
              page: const SSSeniorShowMembersList(),
              settings: settings,
            );
          case SSSeniorMemberDetails.id:
            return _buildSlideTransition(
              page: const SSSeniorMemberDetails(),
              settings: settings,
            );
          case SSSeniorDailyReport.id:
            return _buildSlideTransition(
              page: const SSSeniorDailyReport(),
              settings: settings,
            );
          case SSeniorDailyReport.id:
            return _buildSlideTransition(
              page: const SSeniorDailyReport(),
              settings: settings,
            );
          case SeniorDailyReport.id:
            return _buildSlideTransition(
              page: const SeniorDailyReport(),
              settings: settings,
            );
          case MasterDailyReport.id:
            return _buildSlideTransition(
              page: const MasterDailyReport(),
              settings: settings,
            );
          case AgentDailyReport.id:
            return _buildSlideTransition(
              page: const AgentDailyReport(),
              settings: settings,
            );
          case UserDailyReport.id:
            return _buildSlideTransition(
              page: const UserDailyReport(),
              settings: settings,
            );
          case SSeniorAdminScreen.id:
            return _buildSlideTransition(
              page: const SSeniorAdminScreen(),
              settings: settings,
            );
          case SSeniorMembers.id:
            return _buildSlideTransition(
              page: const SSeniorMembers(),
              settings: settings,
            );
          case SSeniorShowMembersList.id:
            return _buildSlideTransition(
              page: const SSeniorShowMembersList(),
              settings: settings,
            );
          case TranscationsActionPage.id:
            return _buildSlideTransition(
              page: TranscationsActionPage(
                userId: 0,
                date: '',
              ),
              settings: settings,
            );
          case AgentAdminScreen.id:
            return _buildSlideTransition(
              page: const AgentAdminScreen(),
              settings: settings,
            );
          case AgentMembers.id:
            return _buildSlideTransition(
              page: const AgentMembers(),
              settings: settings,
            );
          case RulesPage.id:
            return _buildSlideTransition(
              page: const RulesPage(),
              settings: settings,
            );
          case RulesPageForRoute.id:
            return _buildSlideTransition(
              page: const RulesPageForRoute(),
              settings: settings,
            );
          case UserHomeScreen.id:
            return _buildSlideTransition(
              page: const UserHomeScreen(),
              settings: settings,
            );
          case BodyBetting.id:
            return _buildSlideTransition(
              page: const BodyBetting(),
              settings: settings,
            );
          case MaungBetting.id:
            return _buildSlideTransition(
              page: const MaungBetting(),
              settings: settings,
            );
          case MatchResults.id:
            return _buildSlideTransition(
              page: const MatchResults(),
              settings: settings,
            );
          case BettingHistory.id:
            return _buildSlideTransition(
              page: const BettingHistory(),
              settings: settings,
            );
          case BodyBetHistoryMatches.id:
            return _buildSlideTransition(
              page: const BodyBetHistoryMatches(),
              settings: settings,
            );
          case MaungBetHistoryMatches.id:
            return _buildSlideTransition(
              page: const MaungBetHistoryMatches(),
              settings: settings,
            );
          case PendingMatches.id:
            return _buildSlideTransition(
              page: const PendingMatches(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Champion Maung')),
              ),
            );
        }
      },
      home: const LoginScreen(),
    );
  }

  PageRouteBuilder _buildSlideTransition({
    required Widget page,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation =
            animation.drive(tween.chain(CurveTween(curve: curve)));
        return SlideTransition(position: offsetAnimation, child: child);
      },
      settings: settings,
    );
  }
}
