// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:first_app/providers/calculation_util.dart';
import 'package:first_app/utils/linear_indicator_core.dart';
import 'package:flutter/material.dart';
import '../utils/linear_indicator_non_core.dart';
import 'package:provider/provider.dart';
import 'package:charcode/charcode.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Attribute_Nft extends StatefulWidget {
  final bool is_core;
  Map<String, int> nftState = {};
  List<RewardItem> rewardList = [];
  Attribute_Nft(
    this.is_core,
    this.nftState,
    this.rewardList,
  );

  @override
  State<Attribute_Nft> createState() => _Attribute_NftState();
}

class _Attribute_NftState extends State<Attribute_Nft> {
  bool isGrammToken = false;
  @override
  Widget build(BuildContext context) {
    int totalScoreToken = 0;
    int totalGrammToken = 0;
    for (RewardItem rewardItem in widget.rewardList) {
      print("<<>>");
      totalScoreToken += rewardItem.lastScoreGained;
      totalGrammToken += rewardItem.grammToken;
    }
    return widget.is_core
        ? Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(3, 27, 52, 1),
                        Color.fromRGBO(3, 27, 52, 1)
                      ],
                    ),
                    border: Border.all(
                        color: Color.fromARGB(255, 80, 57, 164),
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'SPACE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                // height: 1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 127, 191, 124),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.only(
                                  left: 2,
                                  right: 2,
                                  top: 1,
                                  bottom: 1,
                                ),
                                child: ClipRRect(
                                  child: Text(
                                    'Level ${widget.nftState['spaceLevel']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          NeumorphicButton(
                              onPressed: () {
                                ShowUpgradePopupCore(
                                  context,
                                  'SPACE',
                                  widget.nftState['spaceLevel']!,
                                  widget.nftState['spaceLevel']!,
                                  widget.nftState['timeLevel']!,
                                  totalScoreToken,
                                );
                              },
                              style: NeumorphicStyle(
                                depth: 4,
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
                              child: Center(
                                child: Text(
                                  'UPGRADE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      LinearIndicatorCore(widget.nftState['spaceLevel']),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(3, 27, 52, 1),
                        Color.fromRGBO(3, 27, 52, 1)
                      ],
                    ),
                    border: Border.all(
                        color: Color.fromARGB(255, 80, 57, 164),
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'TIME',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                // height: 1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 127, 191, 124),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.only(
                                  left: 2,
                                  right: 2,
                                  top: 1,
                                  bottom: 1,
                                ),
                                child: ClipRRect(
                                  child: Text(
                                    'Level ${widget.nftState['timeLevel']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          NeumorphicButton(
                              onPressed: () {
                                ShowUpgradePopupCore(
                                  context,
                                  'TIME',
                                  widget.nftState['timeLevel']!,
                                  widget.nftState['spaceLevel']!,
                                  widget.nftState['timeLevel']!,
                                  totalScoreToken,
                                );
                              },
                              style: NeumorphicStyle(
                                depth: 4,
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
                              child: Center(
                                child: Text(
                                  'UPGRADE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      LinearIndicatorCore(widget.nftState['timeLevel']),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(3, 27, 52, 1),
                        Color.fromRGBO(3, 27, 52, 1)
                      ],
                    ),
                    border: Border.all(
                        color: Color.fromARGB(255, 80, 57, 164),
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'BATTERY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                // height: 1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 127, 191, 124),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                  top: 1,
                                  bottom: 1,
                                ),
                                child: ClipRRect(
                                  child: Text(
                                    '${widget.nftState['batteryPct']} %',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          NeumorphicButton(
                              onPressed: () async {
                                if (widget.nftState['batteryPct'] == 100) {
                                  await openDialogWhenFull('Battery');
                                } else {
                                  await openDialog(
                                    'Battery',
                                    widget.nftState['batteryPct']!,
                                    totalScoreToken,
                                    totalGrammToken,
                                  );
                                }
                              },
                              style: NeumorphicStyle(
                                depth: 4,
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
                              child: Center(
                                child: Text(
                                  'UPGRADE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LinearIndicator(widget.nftState['batteryPct']),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                // Divider(),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(3, 27, 52, 1),
                        Color.fromRGBO(3, 27, 52, 1)
                      ],
                    ),
                    border: Border.all(
                        color: Color.fromARGB(255, 80, 57, 164),
                        width: 1.0,
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('LAG',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                // height: 1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 127, 191, 124),
                                    borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                  top: 1,
                                  bottom: 1,
                                ),

                                child: ClipRRect(
                                  child: Text(
                                    '${widget.nftState['lagPct']} %',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          NeumorphicButton(
                              onPressed: () async {
                                if (widget.nftState['lagPct'] == 0) {
                                  await openDialogWhenFull('Lag');
                                } else {
                                  await openDialog(
                                    'Lag',
                                    widget.nftState['lagPct']!,
                                    totalScoreToken,
                                    totalGrammToken,
                                  );
                                }
                              },
                              style: NeumorphicStyle(
                                depth: 4,
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
                              child: Center(
                                child: Text(
                                  'UPGRADE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LinearIndicator(widget.nftState['lagPct']),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void ShowUpgradePopupCore(BuildContext context, String attribute, int level,
      int spaceLevel, int timeLevel, int inAppTokens) {
    Provider.of<CalculationUtil>(context, listen: false)
        .calculateUpgradeTokenRequired(level + 1, spaceLevel, timeLevel);
    int tokensNeeded = Provider.of<CalculationUtil>(context, listen: false)
        .upgradeTokenRequired;
    var _isPressedCounter = 0;
    Widget okBtn = NeumorphicButton(
        onPressed: () async {
          _isPressedCounter++;
          if (_isPressedCounter > 1) {
            null;
          } else {
            if (inAppTokens >= tokensNeeded) {
              if (attribute == 'SPACE') {
                await Provider.of<CalculationUtil>(context, listen: false)
                    .upgradeSpaceLevel(level + 1, tokensNeeded)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text('Your ' +
                          attribute +
                          ' has been upgraded! Please refresh.')));
                });
              }
              if (attribute == 'TIME') {
                await Provider.of<CalculationUtil>(context, listen: false)
                    .upgradeTimeLevel(level + 1, tokensNeeded)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text('Your ' +
                          attribute +
                          ' has been upgraded! Please refresh.')));
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.blue,
                  content: Text('You do not have sufficient XP!')));
            }

            Navigator.of(context).pop();
          }
        },
        style: NeumorphicStyle(
          depth: 5,
          intensity: 0.8,
          lightSource: LightSource.topLeft,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
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
        ));

    Widget cancelBtn = NeumorphicButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: NeumorphicStyle(
          depth: 5,
          intensity: 0.8,
          lightSource: LightSource.topLeft,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
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
        ));

    AlertDialog alert = AlertDialog(
      backgroundColor: Color.fromRGBO(3, 27, 52, 1),
      title: Text('You have chosen to upgrade your NFT ' + attribute,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      content: Container(
        height: 120,
        child: Column(
          children: [
            Text(
                'Your current level is ' +
                    level.toString() +
                    '. You will be upgraded to ' +
                    (level + 1).toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'XP needed:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
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
                Text('Available Tokens:',
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
        ),
      ),
      actions: [cancelBtn, okBtn],
    );

    showDialog(
        context: context,
        builder: (BuildContext buildercontext) {
          return alert;
        });
  }

  Future openDialog(
      String attribute, int level, int inAppTokens, int grammTokens) {
    double tokensNeeded = 10;
    double grammNeeded = 2;
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
        // Divider(),
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
                  if (attribute == 'Battery')
                    Text(
                        'Your current level is ' +
                            level.toString() +
                            '. You will be upgraded to full Battery!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ))
                  else
                    Text(
                        'Your current level is ' +
                            level.toString() +
                            '. Your Lag will be cleared off!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        )),
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
                          if (attribute == 'Battery') {
                            await Provider.of<CalculationUtil>(context,
                                    listen: false)
                                .upgradeBatteryLevel(100, 2, false)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Your ' +
                                      attribute +
                                      ' has been upgraded! Please refresh.')));
                            });
                          }
                          if (attribute == 'Lag') {
                            await Provider.of<CalculationUtil>(context,
                                    listen: false)
                                .upgradeLagLevel(0, 2, false)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Your ' +
                                      attribute +
                                      ' has been upgraded! Please refresh.')));
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text(
                                  'Your do not have sufficient Gramm Tokens!')));
                        }
                      } else {
                        if (inAppTokens >= tokensNeeded) {
                          if (attribute == 'Battery') {
                            await Provider.of<CalculationUtil>(context,
                                    listen: false)
                                .upgradeBatteryLevel(100, 10, true)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Your ' +
                                      attribute +
                                      ' has been upgraded! Pease refresh.')));
                            });
                          }
                          if (attribute == 'Lag') {
                            await Provider.of<CalculationUtil>(context,
                                    listen: false)
                                .upgradeLagLevel(0, 10, true)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  backgroundColor: Colors.blue,
                                  content: Text('Your ' +
                                      attribute +
                                      ' has been upgraded! Please refresh.')));
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text('You do not have sufficient XP!')));
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

  Future openDialogWhenFull(String attribute) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Color.fromRGBO(3, 27, 52, 1),
          title: attribute == 'Battery'
              ? Text(
                  'Upgrade not required. $attribute is already at 100%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Upgrade not required. $attribute is already at 0%',
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
