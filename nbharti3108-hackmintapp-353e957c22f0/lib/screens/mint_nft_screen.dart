// // ignore_for_file: prefer_const_constructors

// import 'dart:ui';

// import 'package:clipboard/clipboard.dart';
// import 'package:first_app/screens/minted_nft_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:provider/provider.dart';
// import '../providers/create_wallet.dart';

// class MintNftScreem extends StatefulWidget {
//   static const routeName = '/mint-nft-screen';

//   const MintNftScreem({Key? key}) : super(key: key);

//   @override
//   State<MintNftScreem> createState() => _MintNftScreemState();
// }

// class _MintNftScreemState extends State<MintNftScreem> {
//   @override
//   initState() {
//     Future.delayed(Duration.zero).then((_) {
//       Provider.of<CreateWallet>(context, listen: false).setPageIndexToDevice(2);
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? acctId = Provider.of<CreateWallet>(context, listen: false).acctId;

//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Container(
//           padding:
//               const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
//           child: Center(
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Align(
//                     alignment: Alignment.topLeft,
//                     child: Text('Wallet Id:',
//                         style: TextStyle(color: Colors.white, fontSize: 16))),
//                 Container(
//                     height: 30,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                     ),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(left: 10, right: 10),
//                             width: 280,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               // border: Border.all(
//                               //     color: Color.fromARGB(3, 189, 189, 189),
//                               //     width: 1.0,
//                               //     style: BorderStyle.solid),
//                             ),
//                             child: Text(
//                               acctId!,
//                               style: TextStyle(
//                                   fontSize: 15, fontWeight: FontWeight.w100),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             color: Colors.white,
//                             child: IconButton(
//                               color: Colors.blue,
//                               icon: Icon(
//                                 Icons.content_copy,
//                                 size: 15,
//                               ),
//                               onPressed: () async {
//                                 await FlutterClipboard.copy(acctId);
//                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                     backgroundColor: Colors.blue,
//                                     content: Text(
//                                         'Wallet Id has been copied to clipboard')));
//                               },
//                             ),
//                           ),
//                         ])),
//                 Center(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.all(Radius.circular(10)),
//                     child: Container(
//                       margin: EdgeInsets.all(40),
//                       height: 270,
//                       width: 270,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: ExactAssetImage('lib/icons/nft_base.png'),
//                         ),
//                       ),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.0)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Divider(
//                   thickness: 0.1,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color.fromRGBO(3, 27, 52, 1),
//                   ),
//                   padding: EdgeInsets.all(15),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Text(
//                             'Minting Fee :',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           Text(
//                             '100  MATIC',
//                             style: TextStyle(
//                               color: Colors.white,
//                               decoration: TextDecoration.lineThrough,
//                               decorationColor: Colors.white,
//                               // decorationStyle: TextDecorationStyle.solid,
//                               decorationThickness: 1.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.circular(10)),
//                             padding: EdgeInsets.only(
//                               left: 8,
//                               right: 8,
//                               top: 2,
//                               bottom: 2,
//                             ),
//                             child: ClipRRect(
//                               child: Text(
//                                 'Limited Time Offer',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '0  MATIC',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 NeumorphicButton(
//                   onPressed: () {
//                     // print(userRating);
//                     // print(_isLoading);
//                     Navigator.of(context).pushNamed(MintedNftScreen.routeName);
//                   },
//                   style: NeumorphicStyle(
//                     depth: 4,
//                     intensity: 0.8,

//                     //color: Color.fromARGB(255, 159, 85, 51),
//                     color: Color.fromARGB(255, 20, 131, 187),
//                     lightSource: LightSource.bottom,

//                     shape: NeumorphicShape.convex,
//                     boxShape:
//                         NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
//                   ),
//                   padding: const EdgeInsets.only(
//                       top: 5.0, bottom: 5, left: 15, right: 15),
//                   child: const Text('Mint NOW!',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
