import 'package:async/async.dart';
import 'package:first_app/providers/linkAccount.dart';
import 'package:first_app/screens/reward_refresh_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calculation_util.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RewardsScreen extends StatefulWidget {
  static const routeName = '/rewards-screen';
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final DateFormat formatter = DateFormat('dd-MM-yy');
  late Future<void> _futureRewardFunctions;
  // List<Widget> rewardDetails = [];
  List<RewardItem> _rewardList = [];
  int totalScore = 0;
  int totalGramm = 0;
  bool hasAtleastOneHandle = false;

  @override
  void initState() {
    _futureRewardFunctions = _getRewardList(context);
    super.initState();
  }

  Future<void> _getRewardList(BuildContext context) async {
    print("...running reward functions...");
    totalScore = 0;
    totalGramm = 0;
    await Provider.of<LinkAccount>(context, listen: false)
        .getUsercodingDataFromDevice();
    hasAtleastOneHandle =
        Provider.of<LinkAccount>(context, listen: false).hasAtleastOneHandle();
    await Provider.of<CalculationUtil>(context, listen: false)
        .fetchRewardList();
    _rewardList =
        Provider.of<CalculationUtil>(context, listen: false).rewardList;

    /*
    Removing items from reward list where both gramm and score is 0.
    This happens when a user submits only incorrect submission. 
    The record is kept for such submissions for imposing submission count limit. 
    */
    _rewardList.removeWhere(
        (reward) => (reward.lastScoreGained == 0 && reward.grammToken == 0));
    _rewardList
        .sort((a, b) => b.lastRewardedTime.compareTo(a.lastRewardedTime));
    //rewardDetails = _rewardList.map((item) => RewardItemWidget(item)).toList();
    if (_rewardList.isNotEmpty) {
      for (RewardItem rewardItem in _rewardList) {
        totalScore += rewardItem.lastScoreGained;
        totalGramm += rewardItem.grammToken;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // _rewardList = Provider.of<CalculationUtil>(context).rewardList;

    return FutureBuilder(
      future: _futureRewardFunctions,
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _getRewardList(ctx),
              child: WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Rewards'),
                    backgroundColor: Colors.blueGrey[600],
                    automaticallyImplyLeading: false,
                    // actions: [
                    //   IconButton(
                    //     onPressed: () async {
                    //       await openDialogAirDrop();
                    //     },
                    //     icon: Icon(
                    //       FontAwesomeIcons.parachuteBox,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ],
                  ),
                  backgroundColor: Colors.black,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          // color: Colors.black,
                          margin: EdgeInsets.only(left: 5, right: 5),
                          padding: const EdgeInsets.all(5),
                          height: 65,
                          width: double.infinity,
                          child: Card(
                            color: Color.fromRGBO(3, 27, 52, 1),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 80, 57, 164),
                                    width: 1.0,
                                    style: BorderStyle.solid),
                              ),
                              // padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 10, top: 10, right: 5),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       const Text(
                                  //         'Total  XP:',
                                  //         style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 16,
                                  //           fontWeight: FontWeight.w400,
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(right: 10),
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           children: [
                                  //             Icon(
                                  //               FontAwesomeIcons.coins,
                                  //               color: Colors.orange,
                                  //               size: 12,
                                  //             ),
                                  //             SizedBox(
                                  //               width: 5,
                                  //             ),
                                  //             Text(
                                  //               '$totalScore',
                                  //               style: const TextStyle(
                                  //                 color: Colors.white,
                                  //                 fontSize: 16,
                                  //                 fontWeight: FontWeight.w400,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(height: 5),
                                  // Divider(
                                  //   color: Colors.white,
                                  //   thickness: 0.1,
                                  // ),
                                  // SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 5, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total Gramms:',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.coins,
                                                color: Colors.orange,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '$totalGramm',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(
                          thickness: 0.1,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          alignment: AlignmentDirectional.topStart,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Rewards/Upgrades',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 63, 114, 203),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              NeumorphicButton(
                                onPressed: () async {
                                  Navigator.of(context).pushReplacementNamed(
                                      RewardsRefreshScreen.routeName);
                                },
                                style: NeumorphicStyle(
                                  depth: 4,
                                  intensity: 0.8,

                                  //color: Color.fromARGB(255, 159, 85, 51),
                                  color: Color.fromARGB(255, 20, 131, 187),
                                  lightSource: LightSource.bottom,

                                  shape: NeumorphicShape.convex,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(4)),
                                ),
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      'Refresh',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          // child: const
                          //
                        ),
                        SizedBox(height: 5),
                        Divider(thickness: 0.1, color: Colors.white),
                        SizedBox(height: 5),

                        // SizedBox(height: 5),
                        _rewardList.isNotEmpty
                            ? SingleChildScrollView(
                                child: Container(
                                // margin: EdgeInsets.all(25),
                                // padding: EdgeInsets.all(25),
                                //children: rewardDetails,
                                child: buildDataTable(_rewardList),
                              ))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'No rewards yet.',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  hasAtleastOneHandle
                                      ? const Text(
                                          'Start practicing.',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Link atleast one coding account.',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future openDialogAirDrop() {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => const AlertDialog(
          backgroundColor: Color.fromRGBO(3, 27, 52, 1),
          title: Text(
            'You have no air drops yet.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable(List<RewardItem> _rewardList) {
    final columns = ['Date', 'Gramm', 'Source'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(_rewardList),
      columnSpacing: 80,
      dataRowHeight: 60,
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ))
      .toList();

  List<DataRow> getRows(List<RewardItem> rewardItem) =>
      rewardItem.map((RewardItem reward) {
        int scoregained = reward.lastScoreGained;
        int grammToken = reward.grammToken;
        String? platform = reward.platform;

        int lastRewardedTimeEpoch = reward.lastRewardedTime;
        DateTime lastRewardedTime =
            DateTime.fromMillisecondsSinceEpoch(lastRewardedTimeEpoch * 1000);
        DateFormat formatterDate = DateFormat('MMMd');
        DateFormat formatterTime = DateFormat('jm');
        String formattedDate = formatterDate.format(lastRewardedTime);
        String formattedTime = formatterTime.format(lastRewardedTime);

        // if (grammToken > 0 && scoregained > 0) {
        if (grammToken > 0) {
          return DataRow(cells: [
            DataCell(
              Text(
                '$formattedDate, $formattedTime',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // DataCell(
            //   Text(
            //     scoregained.toString(),
            //     style: const TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            DataCell(
              Text(
                grammToken.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            DataCell(
              Container(
                // padding: const EdgeInsets.only(
                //     left: 10, right: 10, top: 10, bottom: 10),
                child: platform == 'cf'
                    ? Image.asset(
                        'lib/icons/code-forces.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      )
                    : platform == 'gfg'
                        ? Image.asset(
                            'lib/icons/geeksforgeeks.png',
                            height: 30.0,
                            fit: BoxFit.cover,
                          )
                        : platform == 'lc'
                            ? Image.asset(
                                'lib/icons/leetcode.png',
                                height: 30.0,
                                fit: BoxFit.cover,
                              )
                            : const Text(
                                '--',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
              ),
            ),
          ]);
        } else if (grammToken == -1) {
          return DataRow(cells: [
            DataCell(
              Text(
                '$formattedDate, $formattedTime',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // DataCell(
            //   Text(
            //     scoregained.toString(),
            //     style: const TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            DataCell(
              const Text(
                '--',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            DataCell(
              Container(
                // padding: const EdgeInsets.only(
                //     left: 10, right: 10, top: 10, bottom: 10),
                child: Image.asset(
                  'lib/icons/icons-settings.png',
                  height: 30.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ]);
        } else if (scoregained == -1) {
          return DataRow(cells: [
            DataCell(
              Text(
                '$formattedDate, $formattedTime',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // DataCell(
            //   const Text(
            //     '--',
            //     style: TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            DataCell(
              Text(
                grammToken.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            DataCell(
              Container(
                // padding: const EdgeInsets.only(
                //     left: 10, right: 10, top: 10, bottom: 10),
                child: platform == 'upgrade'
                    ? Image.asset(
                        'lib/icons/icons-settings.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      )
                    : platform == 'session'
                        ? Image.asset(
                            'lib/icons/sessions.png',
                            height: 30.0,
                            fit: BoxFit.cover,
                          )
                        : platform == 'marketplace'
                            ? Image.asset(
                                'lib/icons/marketplace.png',
                                height: 30.0,
                                fit: BoxFit.cover,
                              )
                            : const Text(
                                '--',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
              ),
            ),
          ]);
        } else {
          return DataRow(cells: [
            DataCell(Text("")),
            // DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ]);
        }
      }).toList();
}
