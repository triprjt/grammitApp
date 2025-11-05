// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names
// import 'dart:async';
// // import 'dart:html';
// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/gestures.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// // import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../providers/create_wallet.dart';
// import 'package:provider/provider.dart';

// class WalletScreen extends StatefulWidget {
//   static const routeName = '/wallet-screen';
//   const WalletScreen({Key? key}) : super(key: key);

//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }

// class _WalletScreenState extends State<WalletScreen> {
//   static String? acctId = '';

//   // Url uri = https//:grammit.club;

//   Future<void> _getWalletId() async {
//     await Provider.of<CreateWallet>(context, listen: false).getUserDataFromDB();
//     acctId = Provider.of<CreateWallet>(context, listen: false).acctId;
//   }

//   //static String nameGeeks = 'bhartiiitg';

//   //final url = Uri.https('polygonscan.com', '/');

//   //final url = Uri.https('auth.geeksforgeeks.org', '/user/$nameGeeks/practice');

//   // final url = Uri.https(
//   //     'polygonscan.com', '/address/0x33A26813Ab17b25030D73346065c3A9e7772e14d');

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _getWalletId(),
//       builder: (ctx, snapshot) => snapshot.connectionState ==
//               ConnectionState.waiting
//           ? const Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.white,
//                 color: Colors.black,
//               ),
//             )
//           : Scaffold(
//               appBar: AppBar(
//                   title: const Text('My Wallet'),
//                   backgroundColor: Colors.blueGrey[600],
//                   actions: [
//                     IconButton(
//                       onPressed: () async {
//                         final url =
//                             Uri.https('polygonscan.com', '/address/$acctId');
//                         print('###########');
//                         print(url);
//                         print('#############');
//                         if (!await launchUrl(url)) {
//                           throw 'Could not launch $url';
//                         }
//                       },
//                       icon: Icon(FontAwesomeIcons.externalLinkAlt),
//                       iconSize: 16,
//                     ),
//                   ]),
//               body: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   //     gradient: LinearGradient(
//                   //   begin: Alignment.topCenter,
//                   //   end: Alignment.bottomCenter,
//                   //   colors: [Color.fromARGB(212, 7, 4, 10), Color.fromARGB(68, 10, 7, 5)],
//                   // )
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(top: 25),
//                       padding: const EdgeInsets.only(
//                         left: 5,
//                         top: 5,
//                         bottom: 5,
//                         right: 4,
//                       ),
//                       height: 120,
//                       width: double.infinity,
//                       child: Card(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Color.fromARGB(255, 80, 57, 164),
//                                 width: 1.0,
//                                 style: BorderStyle.solid),
//                           ),
//                           padding: const EdgeInsets.only(
//                               left: 10, right: 10, top: 10, bottom: 10),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Container(
//                                 height: 40,
//                                 padding: EdgeInsets.only(right: 10),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       child: Text('Wallet Address:',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 22,
//                                               fontWeight: FontWeight.bold)),
//                                     ),
//                                     Text(
//                                       'Polygon Network',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 12,
//                                           fontStyle: FontStyle.italic),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                       margin: EdgeInsets.only(left: 5),
//                                       width: 300,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         // border: Border.all(
//                                         //     color: Color.fromARGB(3, 189, 189, 189),
//                                         //     width: 1.0,
//                                         //     style: BorderStyle.solid),
//                                       ),
//                                       child: Text(
//                                         acctId!,
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w100),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     Container(
//                                       color: Colors.white,
//                                       child: IconButton(
//                                         color: Colors.blue,
//                                         icon: Icon(
//                                           Icons.content_copy,
//                                           size: 15,
//                                         ),
//                                         onPressed: () async {
//                                           await FlutterClipboard.copy(acctId!);
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                                   backgroundColor: Colors.blue,
//                                                   content: Text(
//                                                       'Wallet address has been copied to clipboard')));
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         color: Color.fromRGBO(3, 27, 52, 1),
//                       ),
//                     ),
//                     SizedBox(height: 25),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Column(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white, shape: BoxShape.circle),
//                               child: IconButton(
//                                 color: Color.fromARGB(255, 6, 10, 55),
//                                 icon: Icon(
//                                   Icons.send_sharp,
//                                   size: 30,
//                                 ),
//                                 onPressed: () async {
//                                   await FlutterClipboard.copy(acctId!);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           backgroundColor: Colors.blue,
//                                           content: Text('Coming soon..')));
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               height: 4,
//                             ),
//                             Text(
//                               'SEND',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white, shape: BoxShape.circle),
//                               child: IconButton(
//                                 color: Color.fromARGB(255, 6, 10, 55),
//                                 focusColor: Colors.black,
//                                 icon: Icon(
//                                   Icons.vertical_align_bottom,
//                                   size: 30,
//                                 ),
//                                 onPressed: () async {
//                                   await FlutterClipboard.copy(acctId!);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           backgroundColor: Colors.blue,
//                                           content: Text('Coming soon ..')));
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               'RECIEVE',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white, shape: BoxShape.circle),
//                               child: IconButton(
//                                 color: Color.fromARGB(255, 6, 10, 55),
//                                 icon: Icon(
//                                   Icons.transform_outlined,
//                                   size: 30,
//                                 ),
//                                 onPressed: () async {
//                                   await FlutterClipboard.copy(acctId!);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                           backgroundColor: Colors.blue,
//                                           content: Text('Coming soon ..')));
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               height: 4,
//                             ),
//                             Text(
//                               'TRADE',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Divider(
//                       color: Colors.white,
//                       thickness: 0.1,
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       padding: EdgeInsets.only(right: 10),
//                       margin: EdgeInsets.only(left: 10, right: 10),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.centerRight,
//                             colors: [
//                               Color.fromRGBO(3, 27, 52, 1),
//                               Color.fromRGBO(3, 27, 52, 1)
//                             ]
//                             // colors: [
//                             //   Color.fromARGB(255, 46, 77, 255),
//                             //   Color.fromARGB(255, 6, 10, 55)
//                             // ],
//                             ),
//                         border: Border.all(
//                             color: Color.fromARGB(255, 80, 57, 164),
//                             width: 1.0,
//                             style: BorderStyle.solid),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 10, top: 10, bottom: 10),
//                                 child: Image.asset(
//                                   'lib/icons/polygon-token.png',
//                                   height: 30.0,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               Text(
//                                 'Polygon',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               )
//                             ],
//                           ),
//                           Text('0.00 MATIC',
//                               style:
//                                   TextStyle(fontSize: 15, color: Colors.white))
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(right: 10),
//                       margin: EdgeInsets.only(left: 10, right: 10),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                           colors: [
//                             Color.fromRGBO(3, 27, 52, 1),
//                             Color.fromRGBO(3, 27, 52, 1)
//                           ],
//                         ),
//                         border: Border.all(
//                             color: Color.fromARGB(255, 80, 57, 164),
//                             width: 1.0,
//                             style: BorderStyle.solid),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.only(
//                                     left: 10, right: 10, top: 10, bottom: 10),
//                                 child: Image.asset(
//                                   'lib/icons/grammit.webp',
//                                   height: 30.0,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               Text(
//                                 'GrammIt',
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               )
//                             ],
//                           ),
//                           Text('0.00 GRAMM',
//                               style:
//                                   TextStyle(fontSize: 15, color: Colors.white))
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                         margin: EdgeInsets.only(left: 10, right: 10),
//                         child: Center(
//                           child: Text(
//                             'Copy wallet address & trasfer Matic from your exchange account or Metamask like wallet.',
//                             style: TextStyle(fontSize: 15, color: Colors.white),
//                           ),
//                         )),
//                     SizedBox(height: 10),
//                     Container(
//                         margin: EdgeInsets.only(left: 10, right: 10),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: RichText(
//                             text: TextSpan(
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                                 color: Colors.white,
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(text: 'Only use '),
//                                 TextSpan(
//                                     text: 'Polygon Network ',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold)),
//                                 TextSpan(text: 'to transfer funds.'),
//                               ],
//                             ),
//                           ),
//                         )),
//                     Divider(
//                       color: Colors.white,
//                       thickness: 0.1,
//                     ),
//                     SizedBox(height: 50),
//                     Container(
//                       margin: EdgeInsets.only(left: 10, right: 10),
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'To learn more   ',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             // TextSpan(
//                             //   text: 'Click here',
//                             //   style: TextStyle(color: Colors.green, fontSize: 15),
//                             //   recognizer: TapGestureRecognizer()
//                             //     ..onTap = () async {
//                             //       var url = "hhtps://www.google.com";
//                             //       if (await canLaunch(url)) {
//                             //         await launch(url);
//                             //       } else {
//                             //         throw 'Cannot load Url';
//                             //       }
//                             //     },
//                             // ),
//                             NeumorphicButton(
//                                 onPressed: () async {
//                                   // launchUrl(uri);
//                                   final Uri url =
//                                       Uri.parse('https://grammit.club');
//                                   if (!await launchUrl(url)) {
//                                     throw 'Could not launch $url';
//                                   }
//                                 },
//                                 style: NeumorphicStyle(
//                                   // depth: 5,
//                                   // intensity: 0.8,
//                                   lightSource: LightSource.bottom,
//                                   shape: NeumorphicShape.convex,
//                                   boxShape: NeumorphicBoxShape.roundRect(
//                                       BorderRadius.circular(4)),
//                                 ),
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Center(
//                                   child: Text(
//                                     'Click me',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 10,
//                                     ),
//                                   ),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
