// import 'dart:ui';

// import 'package:first_app/providers/calculation_util.dart';
// import 'package:first_app/screens/bottom_navigation_bar_screen.dart';
// import 'package:first_app/screens/nftScreen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:provider/provider.dart';
// import '../providers/create_wallet.dart';

// class MintedNftScreen extends StatefulWidget {
//   static const routeName = '/minted-nft-screen';

//   const MintedNftScreen({Key? key}) : super(key: key);

//   @override
//   State<MintedNftScreen> createState() => _MintedNftScreenState();
// }

// class _MintedNftScreenState extends State<MintedNftScreen> {
//   @override
//   initState() {
//     Future.delayed(Duration.zero).then((_) {
//       Provider.of<CreateWallet>(context, listen: false)
//           .setPageIndexToDevice(3)
//           .then((_) {
//         Provider.of<CalculationUtil>(context, listen: false)
//             .postInitialNftState();
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
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
//                         filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.0)),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Text(
//                   'Congratulations!',
//                   style: TextStyle(color: Colors.white, fontSize: 22),
//                 ),
//                 SizedBox(height: 10),
//                 const Text(
//                   'Your NFT is minted!',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 const Text(
//                   'Your NFT will be transferred to your wallet within 24 hrs.',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Divider(thickness: 0.1, color: Colors.white),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 NeumorphicButton(
//                   onPressed: () {
//                     // print(userRating);
//                     // print(_isLoading);
//                     Navigator.of(context).pushNamed(BottomNavScreen.routeName);
//                   },
//                   style: NeumorphicStyle(
//                     depth: 4,
//                     intensity: 0.8,
//                     border: NeumorphicBorder(
//                       color: Color.fromARGB(51, 13, 1, 1),
//                       width: 0.8,
//                     ),

//                     //color: Color.fromARGB(255, 159, 85, 51),
//                     color: Color.fromARGB(255, 20, 131, 187),
//                     lightSource: LightSource.bottom,

//                     shape: NeumorphicShape.convex,
//                     boxShape:
//                         NeumorphicBoxShape.roundRect(BorderRadius.circular(4)),
//                   ),
//                   padding: const EdgeInsets.only(
//                       top: 5.0, bottom: 5, left: 15, right: 15),
//                   child: const Text('PROCEED',
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
