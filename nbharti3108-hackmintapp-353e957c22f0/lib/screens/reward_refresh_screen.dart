import 'package:first_app/screens/bottom_navigation_bar_screen.dart';
import 'package:first_app/screens/rewards_screen.dart';
import 'package:first_app/screens/toggle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:async/async.dart';
import 'package:first_app/providers/linkAccount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calculation_util.dart';

class RewardsRefreshScreen extends StatefulWidget {
  static const routeName = '/rewards-refresh-screen';
  const RewardsRefreshScreen({Key? key}) : super(key: key);

  @override
  State<RewardsRefreshScreen> createState() => _RewardsRefreshScreenState();
}

class _RewardsRefreshScreenState extends State<RewardsRefreshScreen> {
  int totalScore = 0;
  int totalGramm = 0;
  late Future<void> _futureFunctions;

  Map<String, int> nftState = {};
  List<RewardItem> _rewardList = [];

  Future<void> runInParallelFutures() async {
    final futureGroup = FutureGroup();
    futureGroup.add(Provider.of<LinkAccount>(context, listen: false)
        .getLastestLeetcodeState());
    futureGroup.add(
        Provider.of<LinkAccount>(context, listen: false).getLatestGfgState());
    futureGroup.close();
    await futureGroup.future;
  }

  @override
  void initState() {
    // _futureFunctions = _updateNftParameters(context);
    _futureFunctions = _updateNftParameters(context);
    super.initState();
  }

  Future<void> _updateNftParameters(BuildContext context) async {
    print("... running future functions .....");
    totalScore = 0;
    totalGramm = 0;
    await Provider.of<LinkAccount>(context, listen: false)
        .getUsercodingDataFromDevice();
    await Provider.of<LinkAccount>(context, listen: false)
        .getCompleteSubmissionList();
    //print("line1 is here.......");
    await runInParallelFutures();
    //print("line2 is here .......");
    Provider.of<LinkAccount>(context, listen: false).calculateNftParameters();
    //print("line3 is here .......");
    await Provider.of<LinkAccount>(context, listen: false)
        .postRewardsToFirebase();
    //print("line4 is here .....");
    // await Provider.of<LinkAccount>(context, listen: false).updateNftState();
    await Provider.of<LinkAccount>(context, listen: false)
        .setUsercodingDataToDevice();
    // await Provider.of<CalculationUtil>(context, listen: false)
    // .fetchRewardList();
    // dailyScore = Provider.of<LinkAccount>(context, listen: false).dailyScore;
    // totalScore = Provider.of<LinkAccount>(context, listen: false).totalScore;
    // nftState = Provider.of<LinkAccount>(context, listen: false).nftState;
    // Provider.of<CalculationUtil>(context, listen: false).rewardList;
    // _rewardList
    // .sort((a, b) => b.lastRewardedTime.compareTo(a.lastRewardedTime));
    //rewardDetails = _rewardList.map((item) => RewardItemWidget(item)).toList();
    // if (_rewardList.isNotEmpty) {
    // for (RewardItem rewardItem in _rewardList) {
    // totalScore += rewardItem.lastScoreGained;
    // totalGramm += rewardItem.grammToken;
    // }
    // }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _futureFunctions,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: const Text('Rewards'),
                backgroundColor: Colors.blueGrey[600],
                automaticallyImplyLeading: false,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Fetching your rewards.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '(This might take a few seconds)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          // snapshot.connectionState == ConnectionState.waiting
          // ? return const Center(
          // child: CircularProgressIndicator(),
          // )
          // :
          //  await Navigator.of(context).pushReplacementNamed(RewardsScreen.routeName);

          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushReplacementNamed(BottomNavScreen.routeName2);
          });
          return Container();
        });
    // return Navigator.of(context).pushReplacementNamed(RewardsScreen.routeName);
  }
}
