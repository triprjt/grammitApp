import 'dart:ui';

import 'package:first_app/providers/challenges_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PairProgrammingScreen extends StatefulWidget {
  static const routeName = '/pairProgramming-screen';
  const PairProgrammingScreen({Key? key}) : super(key: key);

  @override
  State<PairProgrammingScreen> createState() => _PairProgrammingScreenState();
}

class _PairProgrammingScreenState extends State<PairProgrammingScreen> {
  late Future<void> _futurePairStatusFunction;
  bool findMyPairClicked = false;
  bool isLoading = false;
  bool foundAPair = false;

  @override
  void initState() {
    _futurePairStatusFunction = getPairStatus(context);
    super.initState();
  }

  Future<void> getPairStatus(BuildContext context) async {
    print("...getting pair status");
    foundAPair = await Provider.of<ChallengesProvider>(context, listen: false)
        .getPairFoundStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futurePairStatusFunction,
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text('Pair Programming'),
                backgroundColor: Colors.blueGrey[600],
                // automaticallyImplyLeading: false,
              ),
              backgroundColor: Colors.black,
              body: WillPopScope(
                onWillPop: () async => false,
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.all(40),
                          height: 320,
                          width: 320,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('lib/icons/nft_base.png'),
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (findMyPairClicked || foundAPair)
                        ? Column(
                            children: [
                              const Text(
                                'Congratulations! Coding pair found.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: 150,
                                child: NeumorphicButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                        'https://telegram.me/satyam_saurabh');
                                    // 'tg://msg?text=Hello&to=satyam_saurabh');

                                    if (!await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  style: NeumorphicStyle(
                                    depth: 4,
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Connect',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
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
                              ),
                            ],
                          )
                        : NeumorphicButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await Provider.of<ChallengesProvider>(context,
                                      listen: false)
                                  .postPairFoundStatus();
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  isLoading = false;
                                  findMyPairClicked = true;
                                });
                              });
                            },
                            style: NeumorphicStyle(
                              depth: 4,
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
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5, left: 15, right: 15),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : const Text('Find my coding pair',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
