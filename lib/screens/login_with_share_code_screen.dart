// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:first_app/providers/create_wallet.dart';
import 'package:first_app/screens/toggle_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../providers/email_auth_provider.dart';
import '../providers/calculation_util.dart';

class SignInWithSharePage extends StatefulWidget {
  static const routeName = '/login-with-share-screen';
  const SignInWithSharePage({Key? key}) : super(key: key);

  @override
  State<SignInWithSharePage> createState() => _SignInWithSharePageState();
}

class _SignInWithSharePageState extends State<SignInWithSharePage> {
  // final _shareCodeController = TextEditingController();
  // final _emailController = TextEditingController();
  // String shareCode = '';
  // String emailId = '';
  // bool isShareVisible = true;

  @override
  void initState() {
    // _shareCodeController.addListener(() => setState(() {}));
    // _emailController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    // _shareCodeController.dispose();
    // _emailController.dispose();

    super.dispose();
  }

  // void emailSendingMethod(emailId) async {
  //   await Provider.of<CalculationUtil>(context, listen: false)
  //       .fetchemailJsParameters();
  //   final serviceId =
  //       Provider.of<CalculationUtil>(context, listen: false).ServiceId;
  //   final templateId =
  //       Provider.of<CalculationUtil>(context, listen: false).templateId;
  //   final userId = Provider.of<CalculationUtil>(context, listen: false).userId;
  //   var partsArray = emailId.split('@');
  //   var emailName = partsArray[0];
  //   final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'origin': 'http://localhost',
  //       },
  //       body: json.encode({
  //         "service_id": serviceId,
  //         "template_id": templateId,
  //         "user_id": userId,
  //         "template_params": {
  //           "to_name": emailName,
  //           "to_email": emailId,
  //           "user_email": "hello@grammit.club",
  //         },
  //       }),
  //     );
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),

            SizedBox(
              height: 5,
            ),
            Center(
              child: GradientText(
                'Looking for someone to code with ?',
                style: TextStyle(
                  fontSize: 20,
                ),
                colors: [
                  Colors.white,
                  Colors.white,
                  // Colors.teal,
                ],
              ),
            ),

            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  margin: EdgeInsets.all(40),
                  height: 280,
                  width: 280,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('lib/icons/nft_colorful.png'),
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 25),
            // isShareVisible
            //     ? GestureDetector(
            //         onTap: () => FocusScope.of(context).unfocus(),
            //         child: Container(
            //           margin: EdgeInsets.only(left: 20, right: 20),
            //           padding: EdgeInsets.only(left: 5, right: 5),
            //           child: Column(
            //             children: [
            //               Align(
            //                 alignment: Alignment.topLeft,
            //                 child: Text(
            //                     'Have an invite code? Put the code down below!',
            //                     style: TextStyle(color: Colors.white)),
            //               ),
            //               SizedBox(height: 10),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   SizedBox(
            //                     width: 250,
            //                     height: 35,
            //                     child: TextFormField(
            //                       style: TextStyle(color: Colors.black),
            //                       onChanged: (code) =>
            //                           setState(() => shareCode = code),
            //                       // validator: (value) {
            //                       //   if (value!.isEmpty) {
            //                       //     return "Please enter a Code.";
            //                       //   } else if (value == 'GRAMMNIS' ||
            //                       //       value == 'GRAMMGHA' ||
            //                       //       value == 'GRAMMSAT') {
            //                       //     return null;
            //                       //   } else
            //                       //     return "Please enter a valid Code.";
            //                       // },
            //                       controller: _shareCodeController,
            //                       keyboardType: TextInputType.text,
            //                       decoration: InputDecoration(
            //                         fillColor: Colors.white,
            //                         filled: true,
            //                         border: OutlineInputBorder(
            //                           borderSide: BorderSide(
            //                               color: Colors.white, width: 2.0),
            //                         ),
            //                         suffixIcon: _shareCodeController
            //                                 .text.isEmpty
            //                             ? Container(width: 0)
            //                             : IconButton(
            //                                 icon: Icon(
            //                                   Icons.close,
            //                                   color: Colors.white,
            //                                 ),
            //                                 onPressed: () =>
            //                                     _shareCodeController.clear(),
            //                               ),
            //                         floatingLabelBehavior:
            //                             FloatingLabelBehavior.always,
            //                       ),
            //                     ),
            //                   ),
            //                   NeumorphicButton(
            //                       onPressed: () async {
            //                         bool _isValidCode =
            //                             await Provider.of<CreateWallet>(context,
            //                                     listen: false)
            //                                 .checkIfInviteCodeExists(shareCode);
            //                         if (_isValidCode) {
            //                           setState(() {
            //                             isShareVisible = false;
            //                           });
            //                         } else {
            //                           ScaffoldMessenger.of(context)
            //                               .showSnackBar(SnackBar(
            //                                   backgroundColor: Colors.blue,
            //                                   content: Text(
            //                                       'This invite Code is not Valid. Join the Waitlist.')));
            //                         }
            //                       },
            //                       style: NeumorphicStyle(
            //                         depth: 4,
            //                         intensity: 0.8,

            //                         //color: Color.fromARGB(255, 159, 85, 51),
            //                         color: Color.fromARGB(255, 20, 131, 187),
            //                         lightSource: LightSource.bottom,

            //                         shape: NeumorphicShape.convex,
            //                         boxShape: NeumorphicBoxShape.roundRect(
            //                             BorderRadius.circular(4)),
            //                       ),
            //                       padding: const EdgeInsets.all(5.0),
            //                       child: Container(
            //                         width: 60,
            //                         height: 22,
            //                         child: Center(
            //                           child: Text(
            //                             'Submit',
            //                             style: TextStyle(
            //                               fontWeight: FontWeight.bold,
            //                               fontSize: 12,
            //                             ),
            //                           ),
            //                         ),
            //                       ))
            //                 ],
            //               ),
            //               SizedBox(height: 30),
            //               Divider(thickness: 0.2, color: Colors.white),
            //               SizedBox(height: 30),
            //               Align(
            //                 alignment: Alignment.topLeft,
            //                 child: Text(
            //                     'Do not have the Invite Code? Join the Waitlist',
            //                     style: TextStyle(color: Colors.white)),
            //               ),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   SizedBox(
            //                     width: 270,
            //                     height: 40,
            //                     child: TextFormField(
            //                       style: TextStyle(
            //                           color: Colors.white, fontSize: 11),
            //                       onChanged: (email) =>
            //                           setState(() => emailId = email),
            //                       controller: _emailController,
            //                       keyboardType: TextInputType.emailAddress,
            //                       decoration: InputDecoration(
            //                         fillColor: Color.fromRGBO(3, 27, 52, 1),
            //                         filled: true,
            //                         prefixIcon: Icon(
            //                           Icons.email,
            //                           color: Colors.white,
            //                         ),
            //                         hintText: 'Your email address',
            //                         hintStyle: TextStyle(color: Colors.white),
            //                         border: OutlineInputBorder(
            //                           borderSide: BorderSide(
            //                               color: Colors.white, width: 2.0),
            //                         ),
            //                         suffixIcon: _emailController.text.isEmpty
            //                             ? Container(width: 0)
            //                             : IconButton(
            //                                 icon: Icon(
            //                                   Icons.close,
            //                                   color: Colors.black,
            //                                 ),
            //                                 onPressed: () =>
            //                                     _emailController.clear(),
            //                               ),
            //                         floatingLabelBehavior:
            //                             FloatingLabelBehavior.always,
            //                       ),
            //                     ),
            //                   ),
            //                   NeumorphicButton(
            //                       onPressed: () async {
            //                         final bool isValid =
            //                             EmailValidator.validate(emailId);

            //                         if (isValid) {
            //                           emailSendingMethod(emailId);
            //                           await Provider.of<CreateWallet>(context,
            //                                   listen: false)
            //                               .postEmailToDB(emailId)
            //                               .then((_) {
            //                             ScaffoldMessenger.of(context)
            //                                 .showSnackBar(SnackBar(
            //                                     backgroundColor: Colors.blue,
            //                                     content: Text(
            //                                         'Please check your email for the invite code!')));
            //                           });
            //                         } else {
            //                           ScaffoldMessenger.of(context)
            //                               .showSnackBar(SnackBar(
            //                                   backgroundColor: Colors.blue,
            //                                   content: Text(
            //                                       'Please provide a valid email address!')));
            //                         }
            //                       },
            //                       style: NeumorphicStyle(
            //                         depth: 4,
            //                         intensity: 0.8,
            //                         color: Color.fromARGB(255, 240, 109, 16),
            //                         lightSource: LightSource.bottom,
            //                         shape: NeumorphicShape.convex,
            //                         boxShape: NeumorphicBoxShape.roundRect(
            //                             BorderRadius.circular(4)),
            //                       ),
            //                       padding: const EdgeInsets.all(5.0),
            //                       child: Container(
            //                         width: 60,
            //                         height: 26,
            //                         child: Center(
            //                           child: Text(
            //                             'Submit',
            //                             style: TextStyle(
            //                               fontWeight: FontWeight.bold,
            //                               fontSize: 12,
            //                             ),
            //                           ),
            //                         ),
            //                       ))
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     :
            SignInButton(Buttons.Google, onPressed: () async {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              print('google signin page .......');
              await provider.googleLogin();

              if (provider.user.id.isNotEmpty) {
                Navigator.of(context)
                    .pushReplacementNamed(ToggleScreen.routeName);
              }
            })
          ],
        ),
      ),
    );
  }
}
