import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:champion_maung/Routes/UserRoutes/betting_history.dart';
import 'package:champion_maung/Routes/UserRoutes/body_betting.dart';
import 'package:champion_maung/Routes/UserRoutes/match_results.dart';
import 'package:champion_maung/Routes/UserRoutes/maung_betting.dart';
import 'package:champion_maung/Routes/UserRoutes/more.dart';
import 'package:champion_maung/constants.dart';

class AgentScreen extends StatefulWidget {
  static String id = 'agent_screen';
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  var list = ['BODY', 'MAUNG', 'MATCHES RESULTS', 'BETTING HISTORY', 'MORE'];
  var listRoutes = [
    BodyBetting.id,
    MaungBetting.id,
    MatchResults.id,
    BettingHistory.id,
    More.id,
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'CHAMPION MAUNG (Agent)',
          style: TextStyle(
            color: kWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        color: kPrimary,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: height / 100,
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'ဘယ်လိုလောင်းလောင်း PLUS ပေါင်း',
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kOnPrimaryContainer,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: ListTile(
                                title: Text(
                                  list[index],
                                  style: const TextStyle(
                                    color: konPrimary,
                                  ),
                                ),
                                leading: const Icon(
                                  Icons.arrow_right,
                                  color: konPrimary,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, listRoutes[index]);
                                },
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
