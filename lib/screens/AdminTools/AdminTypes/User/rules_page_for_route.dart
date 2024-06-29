import 'package:champion_maung/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class RulesPageForRoute extends StatefulWidget {
  static String id = 'rules_page_for_route';
  const RulesPageForRoute({super.key});

  @override
  State<RulesPageForRoute> createState() => _RulesPageForRouteState();
}

class _RulesPageForRouteState extends State<RulesPageForRoute> {
  List<String> rulesList = [
    '-> Rule 1',
    '-> Rule 2',
    '-> Rule 3',
    '-> Rule 4',
    '-> Rule 5',
    '-> Rule 6',
    '-> Rule 7',
    '-> Rule 8',
    '-> Rule 9',
    '-> Rule 10',
    '-> Rule 11',
    '-> Rule 12',
    '-> Rule 13',
    '-> Rule 14',
  ];

  List<String> ruleText = [
    'ဘော်ဒီများကို အနည်းဆုံး (1000)ကျပ်မှ အများဆုံး(သုံးသိန်း)ကျပ်အထိကစားနိုင်ပါသည်။',
    'မောင်းများကို အနည်းဆုံး (၂)ပွဲမှ (၁၁)ပွဲအထိ ကစားနိုင်ပြီး ၊ ရွေးချယ်ထားသောပွဲစဉ်များအတွင်းမှ ပွဲပျက်(မကန်ဖြစ်ခဲ့ပါက)ခဲ့လျှင် ကျန်ပွဲစဉ်များအတိုင်း အပြောင်းအလဲမရှိ အလျော်အစားဆက်လက်လုပ်ဆောင်ပါမည်။',
    'ရွေးထားသော မောင်းများမှ ပွဲစဉ်အကုန် မကန်ဖြစ်ပါက လောင်းငွေအားပြန်လည်ရရှိပါမည်။',
    'သတ်မှတ်ရက်အတွင်း နောက်တစ်နေ့ 1:30AM အတွင်း result(ပွဲစဉ်မပြီးသော) မထွက်သောပွဲစဉ်များအား အလျော်အစားပြုလုပ်ပေးမည်မဟုတ်ပါ။',
    'ဘော်ဒီ / ဂိုးပေါင်း ကစားရာတွင် ပွဲကြီး ၊ ပွဲသေးပေါ်မူတည်ပြီး အကောက်မတူပါ။ ပွဲကြီး 5% ၊ ပွဲသေး 8% ကောက်ပါသည်။ ပွဲကြီးကို ခဲရောင်ဖြင့်ပြ၍ ပွဲသေးကို အဖြူရောင်ဖြင့် ပိုင်းခြားထားပါသည်။',
    'ဂိုးရလဒ်များကို မြန်မာကြေးထွက်ရှိသော Betting Company (1.ibet789 , 2.Sportbooks365) များဖြင့် အလျော်အစားပြုလုပ်၍ အဆိုပါ Company များမှ 9:00AM ထိမထွက်ရှိပါက 1.Flash Score, 2.Live Score အားကြည့်ရှုပြီး မတွေ့ရှိပါက သက်ဆိုင်ရာ အဖွဲ့ချုပ်၏ ရလဒ်ကို အတည်ပြုပါမည်။',
    'ဂိုးရလဒ်များထည့်သွင်းရာတွင် အချို့ပွဲစဉ်များသည် ညပိုင်းတွင် ရလဒ်တစ်မျိုးထွက်ပေါ်ပြီး မနက်ပိုင်းတွင် ရလဒ်တစ်မျိုးဖြင့် ပြင်ဆင်ပြောင်းလဲထွက်ပေါ်ခြင်းများရှိပါက နေ့ခင်း 12:00PM အထိသာအကြောင်းကြားခြင်းများအား လက်ခံပြင်ဆင်ပြောင်းလဲပေးပါမည်။',
    'အချိန်စောကန်သွားသော ပွဲစဉ်များရှိခဲ့လျှင် အခြား Betting Compnay များနည်းတူမဟုတ်ပဲ Champion Maung တွင် မူလအချိန်အတိုင်းဖွင့်လှစ်ထားမိပါက အဆိုပါပွဲအား cancel match ပြုလုပ်ပါမည်။',
    '2မောင်း အကောက် 15% နှင့် 3မောင်းမှ 11မောင်းအထိ အကောက် 20%',
    'အငြင်းပွားဖွယ်ရာ ကိစ္စများပေါ်ပေါက်လာပါက အများနှင့် နှိုင်းယှဉ်သုံးသပ်ရသည့်အတွက် Champion Maung ၏ ဆုံးဖြတ်ချက်သာ အတည်မှတ်ယူပါမည်။',
    'နည်းပညာချွတ်ယွင်း၍ အခြားသော betting company များနှင့် ဈေးနှုန်းပေါက်ကြေး (လွန်စွာ) ကွဲလွဲဖွင့်လှစ်မိပါက ၎င်းဈေးနှုန်းဖြင့်ကစားထားသော မောင်းနှင့် ဘော်ဒီများအား Cancel ပြုလုပ်ပြီး အရင်ငွေပြန်ပေးပါမည်။',
    'ပုံမှန်မဟုတ်သောပွဲစဉ်များရှိပါက ၎င်းပွဲစဉ်အား အလျော်အစားမပြုလုပ်ပဲ Cancel Match ပြုလုပ်၍ လောင်းကြေးငွေပြန်အမ်းပေးပါမည်။',
    'မောင်း အကောက် % တွင် ပွဲပျက်အားထည့်တွက်ပါသည်။ ဥပမာ - နှစ်မောင်းထိုးထားပြီးတစ်ပွဲပျက်ပါက ဘော်ဒီအကောက်ဖြင့် မကောက်ပဲ နှစ်မောင်းအဖြစ်သာကောက်ပါသည်။',
    'သာမန်ကစားခြင်းမဟုတ်ပဲ ကြေးဟသီးသန်းကြားထိုးကစားပါက အဆိုပါ user ၏ကြားထိုးအကြောင်းအား reject ပြုလုပ်ပါမည်။',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimary,
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: true,
        title: const Text(
          'Rules and Regulations',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
      body: _buildBody(w),
    );
  }

  Widget _buildBody(w) {
    return Container(
      color: kPrimary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kOnPrimaryContainer,
          ),
          child: AnimationLimiter(
            child: ListView.builder(
                padding: EdgeInsets.all(w / 50),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: rulesList.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 2500),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              rulesText(rulesList[index], ruleText[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
