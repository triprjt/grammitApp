// import 'dart:ui';

// import 'package:first_app/screens/wallet_created_screen.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import '../providers/create_wallet.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CreateWalletScreen extends StatelessWidget {
//   static const routeName = '/create-wallet-screen';

//   const CreateWalletScreen({Key? key}) : super(key: key);

//   Future<void> updateWaitlistPage() async {
//     print("//...");
//     const storage = FlutterSecureStorage();
//     try {
//       String? waitlistPage = await storage.read(key: "waitlistPageValue");

//       if (waitlistPage == '1') {
//         print('Waitlist page is being reached multiple times');
//       } else
//         await storage.write(key: "waitlistPageValue", value: '1');
//     } catch (error) {
//       throw error;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _isPressedCounter = 0;
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Container(
//         color: Colors.black,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 100,
//               ),
//               ClipRRect(
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//                 child: Container(
//                   margin: EdgeInsets.all(40),
//                   height: 300,
//                   width: 300,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: ExactAssetImage('lib/icons/nft.png'),
//                     ),
//                   ),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                     child: Container(
//                       decoration:
//                           BoxDecoration(color: Colors.white.withOpacity(0.0)),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               NeumorphicButton(
//                   onPressed: () async {
//                     await updateWaitlistPage();
//                     _isPressedCounter++;

//                     _isPressedCounter > 1
//                         ? null
//                         : Provider.of<CreateWallet>(context, listen: false)
//                             .createWalletFromTatum()
//                             .then(
//                               (_) => Navigator.of(context)
//                                   .pushNamed(WalletCreatedScreen.routeName),
//                             );
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
//                     child: const Center(
//                       child: Text(
//                         'Create new wallet',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
