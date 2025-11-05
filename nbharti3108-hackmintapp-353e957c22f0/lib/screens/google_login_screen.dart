import 'dart:ui';

import 'package:first_app/screens/toggle_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../providers/email_auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/login_with_share_code_screen.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/login-screen';
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  final storage = FlutterSecureStorage();

  Future<bool> checkWaitlistPageStatus() async {
    try {
      String? waitlistPage = await storage.read(key: "waitlistPageValue");
      print(waitlistPage);
      if (waitlistPage == null) {
        return false;
      }
      return true;
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: checkWaitlistPageStatus(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == false) {
              return SignInWithSharePage();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(height: 100),
                Center(
                  child: GradientText(
                    'Grammit',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    colors: [
                      Color.fromARGB(255, 63, 157, 234),
                      Color.fromARGB(255, 173, 86, 79),
                      // Colors.teal,
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: GradientText(
                    'Looking for someone to code with?',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    colors: [
                      Color.fromARGB(255, 132, 186, 229),
                      Color.fromARGB(255, 173, 86, 79),
                      // Colors.teal,
                    ],
                  ),
                ),

                // SizedBox(height: 10),
                Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      margin: EdgeInsets.all(40),
                      height: 350,
                      width: 350,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage('lib/icons/nft_colorful.png'),
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 25),
                SignInButton(Buttons.Google, onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  print('google signin page .......');
                  await provider.googleLogin();

                  print('##########################');
                  if (provider.user.id.isNotEmpty) {
                    Navigator.of(context)
                        .pushReplacementNamed(ToggleScreen.routeName);
                  }

                  print('###########################');
                })
              ],
            );
          },
        ),
      ),
    );
  }
}
