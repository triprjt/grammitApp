import 'package:first_app/providers/create_wallet.dart';
import 'package:first_app/screens/bottom_navigation_bar_screen.dart';
import 'package:first_app/screens/mint_nft_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../providers/linkAccount.dart';
import '../screens/nftScreen.dart';

class LinkAccountScreen extends StatefulWidget {
  static const routeName = '/linkAccount-screen';

  @override
  State<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends State<LinkAccountScreen> {
  final _codeforcesController = TextEditingController();
  final _leetcodeController = TextEditingController();
  final _gfgController = TextEditingController();
  bool _isLoading = false;
  int userRating = -1;
  bool _onSubmitted = false;
  bool _isCFDuplicate = false;
  bool _isLCDuplicate = false;
  bool _isGfgDuplicate = false;
  bool _isCorrectHandleLeetcode = false;
  bool _isCorrectHandleGfg = false;

  bool _isCFSubmitted = false;
  bool _isLCSubmitted = false;
  bool _isGfgSubmitted = false;

  @override
  Widget build(BuildContext context) {
    // double score = 0.0;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Text(
                    'Please add your user handles.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              Divider(
                height: 30,
                thickness: 0.1,
                color: Colors.white,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Codeforces Handle :',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300)),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            enabled: ((_leetcodeController.text.isEmpty ||
                                        _isLCSubmitted) &&
                                    (_gfgController.text.isEmpty ||
                                        _isGfgSubmitted))
                                ? true
                                : false,
                            // textInputAction: TextInputAction.done,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                hintText: 'handle',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 86, 86, 86)),
                                focusColor: Colors.white),
                            controller: _codeforcesController,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (handle) async {
                              setState(() {
                                _onSubmitted = true;
                                _isLoading = true;
                              });

                              await Provider.of<LinkAccount>(context,
                                      listen: false)
                                  .getUserRatingForCodeforces(handle);

                              userRating = Provider.of<LinkAccount>(context,
                                      listen: false)
                                  .userRating;

                              if (userRating != -1) {
                                _isCFDuplicate = await Provider.of<
                                        CreateWallet>(context, listen: false)
                                    .checkIfDuplicateCodeforcesHandle(handle);
                              }
                              if (userRating != -1 && !_isCFDuplicate) {
                                _isCFSubmitted = true;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: userRating == -1
                                      ? const Text(
                                          'Please Submit a correct handle')
                                      : _isCFDuplicate
                                          ? const Text('Handle already in use')
                                          : Text(
                                              'Successfully authenticated. Your cf rating is $userRating'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Leetcode Handle :',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300)),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            enabled: ((_codeforcesController.text.isEmpty ||
                                        _isCFSubmitted) &&
                                    (_gfgController.text.isEmpty ||
                                        _isGfgSubmitted))
                                ? true
                                : false,
                            // textInputAction: TextInputAction.next,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                hintText: 'handle',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 86, 86, 86)),
                                focusColor: Colors.white),
                            controller: _leetcodeController,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (handle) async {
                              setState(() {
                                _onSubmitted = true;
                                _isLoading = true;
                              });

                              _isCorrectHandleLeetcode =
                                  await Provider.of<LinkAccount>(context,
                                          listen: false)
                                      .postLeetCodeInitialStateToDB(handle);
                              if (_isCorrectHandleLeetcode) {
                                _isLCDuplicate =
                                    await Provider.of<CreateWallet>(context,
                                            listen: false)
                                        .checkIfDuplicateLeetcodeHandle(handle);
                              }
                              if (_isCorrectHandleLeetcode && !_isLCDuplicate) {
                                _isLCSubmitted = true;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: _isCorrectHandleLeetcode == false
                                      ? const Text(
                                          'Please Submit a correct handle')
                                      : _isLCDuplicate
                                          ? const Text('Handle already in use')
                                          : const Text(
                                              'Successfully authenticated'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                              // await Provider.of<LinkAccount>(context,
                              // listen: false)
                              // .setUsercodingDataToDevice();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Geeks4Geeks Handle :',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300)),
                        SizedBox(
                          width: 150,
                          child: TextField(
                            enabled: ((_codeforcesController.text.isEmpty ||
                                        _isCFSubmitted) &&
                                    (_leetcodeController.text.isEmpty ||
                                        _isLCSubmitted))
                                ? true
                                : false,
                            // textInputAction: TextInputAction.done,
                            // textInputAction: TextInputAction.done,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                hintText: 'handle',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 86, 86, 86)),
                                focusColor: Colors.white),
                            controller: _gfgController,
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (handle) async {
                              setState(() {
                                _onSubmitted = true;
                                _isLoading = true;
                              });

                              _isCorrectHandleGfg =
                                  await Provider.of<LinkAccount>(context,
                                          listen: false)
                                      .postGfgInitialStateToDB(handle);

                              if (_isCorrectHandleGfg) {
                                _isGfgDuplicate =
                                    await Provider.of<CreateWallet>(context,
                                            listen: false)
                                        .checkIfDuplicateGfgHandle(handle);
                              }

                              if (_isCorrectHandleGfg && !_isGfgDuplicate) {
                                _isGfgSubmitted = true;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: _isCorrectHandleGfg == false
                                      ? const Text(
                                          'Please Submit a correct handle')
                                      : _isGfgDuplicate
                                          ? const Text('Handle already in use')
                                          : const Text(
                                              'Successfully authenticated'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                              // await Provider.of<LinkAccount>(context,
                              // listen: false)
                              // .setUsercodingDataToDevice();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _onSubmitted
                  ? NeumorphicButton(
                      onPressed: () {
                        // print(userRating);
                        // print(_isLoading);
                        (userRating == -1 &&
                                _isCorrectHandleLeetcode == false &&
                                _isCorrectHandleGfg == false)
                            ? null
                            : _isLoading == true
                                ? null
                                : (_isCFDuplicate &&
                                        _isLCDuplicate &&
                                        _isGfgDuplicate)
                                    ? null
                                    : Future.delayed(Duration.zero)
                                        .then((_) => Provider.of<LinkAccount>(
                                                context,
                                                listen: false)
                                            .setUsercodingDataToDevice())
                                        .then(
                                          (_) => Navigator.of(context)
                                              .pushReplacementNamed(
                                                  BottomNavScreen.routeName),
                                        );

                        // Navigator.of(context)
                        // .pushReplacementNamed(MintNftScreem.routeName);
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
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5, left: 15, right: 15),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : const Text('Submit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                    )
                  : const Text(
                      'Please check the blue tick in the keypad',
                    ),
              const Divider(
                height: 30,
                thickness: 0.1,
                color: Colors.white,
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 10, top: 10, bottom: 10),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Note:  ',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text:
                            'We will be adding other platforms soon. We will keep you updated.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // TextButton(
              //   child: const Text(
              //     'Will add later',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onPressed: () {},
              // ),
              NeumorphicButton(
                onPressed: () {
                  _onSubmitted
                      ? null
                      : Navigator.of(context)
                          .pushReplacementNamed(BottomNavScreen.routeName);
                },
                style: NeumorphicStyle(
                  // depth: 2,
                  // intensity: 0.8,
                  border: const NeumorphicBorder(
                    color: Color.fromARGB(51, 13, 1, 1),
                    width: 0.8,
                  ),

                  // color: Color.fromARGB(255, 159, 85, 51),
                  // color: Color.fromARGB(255, 20, 131, 187),
                  color: Color.fromARGB(255, 175, 173, 173),
                  // lightSource: LightSource.bottom,

                  shape: NeumorphicShape.convex,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
                ),
                padding: const EdgeInsets.all(5.0),
                child: _onSubmitted
                    ? const Text(
                        'Skip for now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    : const Text(
                        'Skip for now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
