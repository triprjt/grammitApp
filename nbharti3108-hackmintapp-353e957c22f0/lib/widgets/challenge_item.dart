import 'package:first_app/providers/challenges_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChallengeItem extends StatefulWidget {
  ChallengeInfo challengeInfo;
  ChallengeItem(this.challengeInfo);

  @override
  State<ChallengeItem> createState() => _ChallengeItemState();
}

class _ChallengeItemState extends State<ChallengeItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String challengeName = widget.challengeInfo.challengeName;
    String challengeLevel = widget.challengeInfo.challengeLevel;
    String inviteLink = widget.challengeInfo.inviteLink;
    int challengeStartTimeInEpoch = widget.challengeInfo.challengeStartTime;
    DateTime ChallengeStartTime =
        DateTime.fromMillisecondsSinceEpoch(challengeStartTimeInEpoch * 1000);

    int challengeEndTimeInEpoch = widget.challengeInfo.challengeEndTime;
    DateTime ChallengeEndTime =
        DateTime.fromMillisecondsSinceEpoch(challengeEndTimeInEpoch * 1000);

    DateFormat formatterDate = DateFormat('MMMd');
    DateFormat formatterTime = DateFormat('jm');

    String formattedChallengeStartDate =
        formatterDate.format(ChallengeStartTime);
    String formattedChallengeStartTime =
        formatterTime.format(ChallengeStartTime);

    String formattedChallengeEndDate = formatterDate.format(ChallengeEndTime);
    String formattedChallengeEndTime = formatterTime.format(ChallengeEndTime);
    // print(inviteLink);
    return Container(
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
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 15,
            right: 15,
            left: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      challengeName,
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
                height: 8,
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.6,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text(
                      'Start Date:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      '$formattedChallengeStartDate, $formattedChallengeStartTime',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Text(
                      'End Date:  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      '$formattedChallengeEndDate, $formattedChallengeEndTime',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Colors.white,
                thickness: 0.6,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 2,
                      bottom: 2,
                    ),
                    child: ClipRRect(
                      child: Text(
                        challengeLevel,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  NeumorphicButton(
                    onPressed: () async {
                      final Uri url =
                          Uri.parse('https://telegram.me/$inviteLink');
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $url';
                      }
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
                    child: Row(
                      children: const [
                        Text(
                          'Join the challenge',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          FontAwesomeIcons.telegram,
                          // color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
