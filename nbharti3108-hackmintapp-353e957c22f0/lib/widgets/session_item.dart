// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:first_app/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/calculation_util.dart';

class SessionItem extends StatefulWidget {
  SessionInfo sessionInfo;
  SessionItem(this.sessionInfo);

  @override
  State<SessionItem> createState() => _SessionItemState();
}

class _SessionItemState extends State<SessionItem> {
  var _isLoading = false;

  // we need this extra variable to keep the state of isRegistered preserved.
  // Since isRegistered is there inside build, every time state changes, it sets it back to false
  // And we can't move that field outside build since it's dependent on widget.sessionInfo
  // Same readon for field _grammSpent. We need to keep a tab on gramm spent because totalGram won't change while on this page
  var _isRegisteredUpdated = false;
  int grammTokens = 0;

  Future<void> _updateGrammTokens(BuildContext context) async {
    print("...fetching updated gramm tokens...");
    await Provider.of<CalculationUtil>(context, listen: false)
        .fetchRewardList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int sessionTimeEpoch = widget.sessionInfo.timeOfSession;
    DateTime sessionTime =
        DateTime.fromMillisecondsSinceEpoch(sessionTimeEpoch * 1000);

    DateFormat formatterDate = DateFormat('MMMd');
    DateFormat formatterTime = DateFormat('jm');

    String formattedDate = formatterDate.format(sessionTime);
    String formattedTime = formatterTime.format(sessionTime);
    bool isRegistered = widget.sessionInfo.isRegisterd ?? false;

    return Container(
      // margin: EdgeInsets.only(left: 5, right: 5),
      width: size.width,
      padding: EdgeInsets.all(15),
      child: Card(
        color: Color.fromRGBO(3, 27, 52, 1),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Color.fromARGB(255, 80, 57, 164),
                width: 0.5,
                style: BorderStyle.solid),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.meeting_room_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Text(
                      '${widget.sessionInfo.companyName} CV review',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   '${formattedDate}, ${formattedTime}',
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 15,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  Flexible(
                    child: (widget.sessionInfo.totalNumOfUsers -
                                widget.sessionInfo.numOfRegisteredusers) >
                            0
                        ? Text(
                            '(Only ${widget.sessionInfo.totalNumOfUsers - widget.sessionInfo.numOfRegisteredusers} seats left)',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          )
                        : const Text(
                            '(0 seats left)',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      'Reviewer: ${widget.sessionInfo.speakerName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '(${widget.sessionInfo.yearsOfExperience} years experience at ${widget.sessionInfo.companyName})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Benefits :',
                    style: TextStyle(
                      color: Color.fromARGB(255, 203, 159, 159),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),

                  Flexible(
                    child: RichText(
                      maxLines: 4,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "\u2022",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                            text:
                                " 20 mins chat at an allotted time with speaker.\n",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "\u2022",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          TextSpan(
                              text: " 1 time cv review.\n",
                              style: TextStyle(color: Colors.white)),
                          // TextSpan(
                          //   text: "\u2022",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 18),
                          // ),
                          // TextSpan(
                          //     text: " 1 hr session with tips and q&a.",
                          //     style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: const [
                  //     Flexible(
                  //       child: Text(
                  //         '20 mins chat at an allotted time with speaker',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 13,
                  //         ),
                  //       ),
                  //     ),
                  //     Text(
                  //       '1 time cv review from speaker',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 13,
                  //       ),
                  //     ),
                  //     Text(
                  //       '1 hr session with tips and q&a',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 13,
                  //         // fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: const [

                  //   ],
                  // ),
                ],
              ),
              // const SizedBox(
              //   height: 4,
              // ),
              const Divider(
                color: Colors.white,
                thickness: 0.8,
              ),
              // const SizedBox(
              //   height: 4,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fees: ${widget.sessionInfo.entryFee} Gramm',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  NeumorphicButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      grammTokens =
                          Provider.of<CalculationUtil>(context, listen: false)
                              .totalGrammTokensAvailable;
                      print("gramm is - " '$grammTokens');
                      (widget.sessionInfo.totalNumOfUsers -
                                  widget.sessionInfo.numOfRegisteredusers) <=
                              0
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No Seats left.'),
                                backgroundColor: Colors.blue,
                              ),
                            )
                          : isRegistered
                              ? null
                              : (grammTokens >= widget.sessionInfo.entryFee)
                                  ? await Provider.of<SessionProvider>(context,
                                          listen: false)
                                      .adduserToSession(
                                          widget.sessionInfo.sessionId)
                                      .then((_) => _updateGrammTokens(context))
                                      .then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Registered. Details will be sent to mail.'),
                                          backgroundColor: Colors.blue,
                                        ),
                                      );
                                      setState(() {
                                        _isRegisteredUpdated = true;
                                      });
                                      print("..///....");
                                    })
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Insufficient gramm tokens.'),
                                        backgroundColor: Colors.blue,
                                      ),
                                    );

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    style: NeumorphicStyle(
                      depth: 2,
                      intensity: 0.8,
                      border: const NeumorphicBorder(
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
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : (isRegistered || _isRegisteredUpdated)
                            ? const Text(
                                'Registered',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
