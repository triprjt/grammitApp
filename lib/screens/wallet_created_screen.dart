// import 'dart:ui';

// import 'package:first_app/providers/create_wallet.dart';
// import 'package:first_app/screens/linkAccountScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/create_wallet.dart';
// import 'package:clipboard/clipboard.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:math' as math;

// class WalletCreatedScreen extends StatefulWidget {
//   static const routeName = '/wallet-created-screen';

//   const WalletCreatedScreen({Key? key}) : super(key: key);

//   @override
//   State<WalletCreatedScreen> createState() => _WalletCreatedScreenState();
// }

// class _WalletCreatedScreenState extends State<WalletCreatedScreen>
//     with TickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     duration: const Duration(milliseconds: 500),
//     vsync: this,
//   )..repeat(reverse: true);

//   bool hasChecked = false;

//   @override
//   initState() {
//     Future.delayed(Duration.zero).then((_) {
//       Provider.of<CreateWallet>(context, listen: false).setPageIndexToDevice(1);
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String? acctId = Provider.of<CreateWallet>(context, listen: false).acctId;
//     String? mnemonic =
//         Provider.of<CreateWallet>(context, listen: false).mnemonic;

//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SingleChildScrollView(
//           child: Container(
//             margin: EdgeInsets.only(top: 30),
//             padding:
//                 const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   // width: double.infinity,
//                   // padding: EdgeInsets.only(right: 10),
//                   // margin: EdgeInsets.only(left: 10, right: 10),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                       colors: [
//                         Color.fromRGBO(3, 27, 52, 1),
//                         Color.fromRGBO(3, 27, 52, 1)
//                       ],
//                     ),
//                     border: Border.all(
//                         color: Color.fromARGB(255, 80, 57, 164),
//                         width: 1.0,
//                         style: BorderStyle.solid),
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.only(
//                         left: 10, right: 10, top: 10, bottom: 10),
//                     child: const Text(
//                       'Your wallet is successfully created!',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Divider(color: Colors.white, thickness: 0.1),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   height: 40,
//                   padding: EdgeInsets.only(right: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         child: Text('Wallet Address:',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       Text(
//                         'Polygon Network',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontStyle: FontStyle.italic),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(left: 5),
//                         width: 280,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           // border: Border.all(
//                           //     color: Color.fromARGB(3, 189, 189, 189),
//                           //     width: 1.0,
//                           //     style: BorderStyle.solid),
//                         ),
//                         child: Text(
//                           acctId!,
//                           style: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.w100),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(
//                         color: Colors.white,
//                         child: IconButton(
//                           color: Colors.blue,
//                           icon: Icon(
//                             Icons.content_copy,
//                             size: 15,
//                           ),
//                           onPressed: () async {
//                             await FlutterClipboard.copy(acctId);
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 backgroundColor: Colors.blue,
//                                 content: Text(
//                                     'Wallet address has been copied to clipboard')));
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Divider(color: Colors.white, thickness: 0.1),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Text('Wallet Mnemonic:',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold)),
//                 ),
//                 SizedBox(height: 10),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color.fromRGBO(3, 27, 52, 1),
//                         Color.fromRGBO(3, 27, 52, 1),
//                       ],
//                     ),
//                     border: Border.all(
//                         color: Color.fromARGB(255, 242, 241, 245),
//                         width: 3,
//                         style: BorderStyle.solid),
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.only(
//                         left: 10, right: 10, top: 15, bottom: 30),
//                     child: Text(
//                       mnemonic!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         letterSpacing: 2,
//                         wordSpacing: 3,
//                         color: Color.fromRGBO(192, 192, 192, 1),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w300,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Divider(color: Colors.white, thickness: 0.1),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 AnimatedBuilder(
//                   animation: _controller,
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [Colors.black, Colors.black],
//                       ),
//                       border: Border.all(
//                           color: Color.fromARGB(255, 80, 57, 164),
//                           width: 1.0,
//                           style: BorderStyle.solid),
//                     ),
//                     child: Text(
//                       'Kindly note down your mnemonic on paper. This is very important for accessing your account later.',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   builder: (BuildContext context, Widget? child) {
//                     return Transform.rotate(
//                       angle: _controller.value * 0.02 * math.pi,
//                       child: child,
//                     );
//                   },
//                 ),
//                 Divider(height: 50, color: Colors.white, thickness: 0.1),
//                 Row(
//                   children: [
//                     Checkbox(
//                       side: MaterialStateBorderSide.resolveWith(
//                         (states) => BorderSide(width: 1.0, color: Colors.white),
//                       ),
//                       focusColor: Colors.white,
//                       checkColor: Colors.black,
//                       activeColor: Colors.white,
//                       value: hasChecked,
//                       onChanged: (hasChecked) => setState(() {
//                         this.hasChecked = hasChecked!;
//                       }),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       'I have noted down the mnemonic!',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 NeumorphicButton(
//                   onPressed: () {
//                     if (!hasChecked) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           backgroundColor: Colors.blue,
//                           content: Text('Please check the checkbox.')));
//                     } else {
//                       Navigator.of(context)
//                           .pushNamed(LinkAccountScreen.routeName);
//                     }
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
//                   padding: const EdgeInsets.all(5.0),
//                   child: Container(
//                     width: 180,
//                     height: 30,
//                     child: Center(
//                       child: Text(
//                         'Link coding accounts',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
