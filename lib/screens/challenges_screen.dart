// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:first_app/providers/challenges_provider.dart';
import 'package:first_app/widgets/app_drawer.dart';
import 'package:first_app/widgets/challenge_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class ChallengesScreen extends StatefulWidget {
  static const routeName = '/challenges-screen';
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late Future<void> _futureChallengesFunction;

  @override
  void initState() {
    _futureChallengesFunction = _getChallengesList(context);
    super.initState();
  }

  Future<void> _getChallengesList(BuildContext context) async {
    print("...getting challenges list");
    await Provider.of<ChallengesProvider>(context, listen: false)
        .fetchChallengesList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<ChallengeInfo> _challengesList = [];
    List<Widget> challengesDetails = [];
    _challengesList = Provider.of<ChallengesProvider>(context, listen: false)
        .getChallengeList;
    challengesDetails = _challengesList
        .map(
          (challengeItem) => ChallengeItem(
            challengeItem,
          ),
        )
        .toList();
    return FutureBuilder(
      future: _futureChallengesFunction,
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
              ),
            )
          : Scaffold(
              drawer: AppDrawer(),
              appBar: AppBar(
                title: const Text('Challenges'),
                backgroundColor: Colors.blueGrey[600],
                // automaticallyImplyLeading: false,
              ),
              backgroundColor: Colors.black,
              body: WillPopScope(
                  onWillPop: () async => false,
                  child: SingleChildScrollView(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _challengesList.isEmpty
                            ? const Center(
                                child: Text(
                                  'No Challenges scheduled.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: challengesDetails,
                                ),
                              ),
                        Column(
                          children: [
                            Center(
                              // ignore: prefer_const_constructors
                              child: Text(
                                'Have a suggestion for us?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 100,
                              child: NeumorphicButton(
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                      'https://forms.gle/22Stfj3JFAw5PJ7AA');
                                  if (!await launchUrl(url,
                                      mode: LaunchMode.externalApplication)) {
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
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
