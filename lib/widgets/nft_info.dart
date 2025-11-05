// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:first_app/providers/calculation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/nft_provier.dart';
import '../utils/circularIndicator.dart';
import 'package:provider/provider.dart';

class NftInfo extends StatefulWidget {
  final Map<String, int> nftState;
  List<RewardItem> rewardList = [];

  NftInfo(this.nftState, this.rewardList);

  @override
  State<NftInfo> createState() => _NftInfoState();
}

class _NftInfoState extends State<NftInfo> {
  bool isGrammToken = false;
  @override
  Widget build(BuildContext context) {
    int totalScoreToken = 0;
    int totalGrammToken = 0;
    for (RewardItem rewardItem in widget.rewardList) {
      totalScoreToken += rewardItem.lastScoreGained;
      totalGrammToken += rewardItem.grammToken;
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // border: Border.all(color: Color.fromARGB(255, 14, 2, 2), width: 1),
        color: Color.fromARGB(255, 6, 1, 1),
        // color: Color.fromARGB(255, 127, 191, 124),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 127, 191, 124),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 2,
                          bottom: 2,
                        ),
                        child: ClipRRect(
                          child: Text(
                            'Health : ${widget.nftState['healthPct']}%',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 18),
                        alignment: Alignment.topLeft,
                        child: NeumorphicButton(
                            onPressed: () async {
                              if (widget.nftState['healthPct'] == 100) {
                                await openDialogWhenFull();
                              } else {
                                await openDialog(
                                  'Health',
                                  widget.nftState['healthPct']!,
                                  totalScoreToken,
                                  totalGrammToken,
                                );
                              }
                            },
                            style: NeumorphicStyle(
                              depth: 2,
                              intensity: 0.8,
                              border: NeumorphicBorder(
                                color: Color.fromARGB(51, 13, 1, 1),
                                width: 0.8,
                              ),

                              //color: Color.fromARGB(255, 159, 85, 51),
                              color: Color.fromARGB(255, 20, 131, 187),
                              lightSource: LightSource.bottom,

                              shape: NeumorphicShape.convex,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(4)),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'UPGRADE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 6,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 127, 191, 124),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 2,
                      bottom: 2,
                    ),
                    child: ClipRRect(
                      child: Text(
                        'Gramm : $totalGrammToken',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
          Center(
            child: ClipRRect(
              child: Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: ExactAssetImage('lib/icons/nft_base.png'),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future openDialog(
      String attribute, int level, int inAppTokens, int grammTokens) {
    int tokensNeeded = 25;
    int grammNeeded = 5;
    int _isPressedCounter = 0;
    Widget stateInAppToken = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text('InApp tokens.',
            //     style: TextStyle(fontSize: 12, color: Colors.white)),
            Text('',
                style: TextStyle(
                  color: Colors.white,
                )),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('XP needed: ',
                style: TextStyle(
                  color: Colors.white,
                )),
            Text(tokensNeeded.toString(),
                style: TextStyle(
                  color: Colors.white,
                )),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Available Tokens: ',
                style: TextStyle(
                  color: Colors.white,
                )),
            Text(inAppTokens.toString(),
                style: TextStyle(
                  color: Colors.white,
                )),
          ],
        ),
        Divider(),
      ],
    );

    Widget stateGrammToken = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text('You have chosen to use Gramm tokens!',
            // style: TextStyle(fontSize: 15, color: Colors.white)),
            // Text('',
            // style: TextStyle(
            // color: Colors.white,
            // )),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Gramms needed: ',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            Text(grammNeeded.toString(),
                style: TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Available Gramms: ',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            Text(grammTokens.toString(),
                style: TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
        Divider(),
      ],
    );

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
            backgroundColor: Color.fromRGBO(3, 27, 52, 1),
            title: Text('Upgrade ' + attribute,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  // if (attribute == 'Battery')
                  Text(
                      'Your current level is ' +
                          level.toString() +
                          '. You will be upgraded to full Health!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      )),
                  // else
                  // Text(
                  //     'Your current level is ' +
                  //         level.toString() +
                  //         '. Your Lag will be cleared off!',
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.white,
                  //     )
                  //     ),
                  Divider(),
                  isGrammToken ? stateInAppToken : stateGrammToken,
                  Container(
                    // color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Use XP instead.',
                          style: TextStyle(color: Colors.white),
                        ),
                        Checkbox(
                          side: MaterialStateBorderSide.resolveWith(
                            (states) =>
                                BorderSide(width: 1.0, color: Colors.white),
                          ),
                          focusColor: Colors.white,
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                          value: isGrammToken,
                          onChanged: (isGrammToken) => setState(() {
                            this.isGrammToken = isGrammToken!;
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              NeumorphicButton(
                  onPressed: () async {
                    _isPressedCounter++;
                    if (_isPressedCounter > 1) {
                      null;
                    } else {
                      if (!isGrammToken) {
                        if (grammTokens >= grammNeeded) {
                          await Provider.of<CalculationUtil>(context,
                                  listen: false)
                              .upgradeHealthLevel(100, 5, false)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.blue,
                                content: Text('Your ' +
                                    attribute +
                                    ' has been upgraded! Please refresh.')));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text(
                                  'Your do not have sufficient Gramm Tokens!')));
                        }
                      } else {
                        if (inAppTokens >= tokensNeeded) {
                          await Provider.of<CalculationUtil>(context,
                                  listen: false)
                              .upgradeHealthLevel(100, 25, true)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.blue,
                                content: Text('Your ' +
                                    attribute +
                                    ' has been upgraded! Please refresh.')));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue,
                              content:
                                  Text('Your do not have sufficient XP!')));
                        }
                      }

                      Navigator.of(context).pop();
                    }
                  },
                  style: NeumorphicStyle(
                    depth: 5,
                    intensity: 0.8,
                    lightSource: LightSource.topLeft,
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 60,
                    child: Center(
                      child: Text(
                        'Upgrade',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )),
              NeumorphicButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: NeumorphicStyle(
                    depth: 5,
                    intensity: 0.8,
                    lightSource: LightSource.topLeft,
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 60,
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ))
            ]),
      ),
    );
  }

  Future openDialogWhenFull() {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color.fromRGBO(3, 27, 52, 1),
          title: Text(
            'Upgrade not required. Health is already at 100%',
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
}
