// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:async/async.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:first_app/screens/lite_nft_screen.dart';
// import '../providers/calculation_util.dart';
// import '../widgets/nft_attribues.dart';
// import 'package:flutter/material.dart';
// import '../providers/nft_provier.dart';
// import '../widgets/nft_info.dart';
// import '../widgets/app_drawer.dart';
// import '../providers/linkAccount.dart';
// import 'package:provider/provider.dart';
// import '../screens/wallet_screen.dart';

// class NftScreen extends StatefulWidget {
//   static const routeName = '/nft-screen';

//   @override
//   State<NftScreen> createState() => _NftScreenState();
// }

// class _NftScreenState extends State<NftScreen> with TickerProviderStateMixin {
//   final nftprofile = NftProfile.generateProfile();
//   String? uid;
//   late Future<void> _futureFunctions;
//   Map<String, int> nftState = {};
//   List<RewardItem> _rewardList = [];

//   Future<void> runInParallelFutures() async {
//     final futureGroup = FutureGroup();
//     futureGroup.add(Provider.of<LinkAccount>(context, listen: false)
//         .getLastestLeetcodeState());
//     futureGroup.add(
//         Provider.of<LinkAccount>(context, listen: false).getLatestGfgState());
//     futureGroup.close();
//     await futureGroup.future;
//   }

//   @override
//   void initState() {
//     _futureFunctions = _updateNftParameters(context);
//     super.initState();
//     uid = FirebaseAuth.instance.currentUser!.uid;
//   }

//   Future<void> _updateNftParameters(BuildContext context) async {
//     print("... running future functions .....");

//     await Provider.of<LinkAccount>(context, listen: false)
//         .getUsercodingDataFromDevice();
//     await Provider.of<LinkAccount>(context, listen: false)
//         .getCompleteSubmissionList();
//     // await Provider.of<LinkAccount>(context, listen: false)
//     //     .addUniqueQuestionToDB();
//     //print("line1 is here.......");
//     await runInParallelFutures();
//     //print("line2 is here .......");
//     await Provider.of<LinkAccount>(context, listen: false).fetchNftState(false);
//     // await Provider.of<LinkAccount>(context, listen: false)
//     //     .getLastestLeetcodeState();
//     // await Provider.of<LinkAccount>(context, listen: false).getLatestGfgState();
//     //print("line3 is here .......");
//     await Provider.of<LinkAccount>(context, listen: false)
//         .postRewardsToFirebase();
//     //print("line4 is here .....");
//     await Provider.of<LinkAccount>(context, listen: false).updateNftState();
//     await Provider.of<LinkAccount>(context, listen: false)
//         .setUsercodingDataToDevice();
//     await Provider.of<CalculationUtil>(context, listen: false)
//         .fetchRewardList();
//     // dailyScore = Provider.of<LinkAccount>(context, listen: false).dailyScore;
//     // totalScore = Provider.of<LinkAccount>(context, listen: false).totalScore;
//     nftState = Provider.of<LinkAccount>(context, listen: false).nftState;
//     _rewardList =
//         Provider.of<CalculationUtil>(context, listen: false).rewardList;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     TabController _tabController = TabController(length: 2, vsync: this);
//     double height = MediaQuery.of(context).size.height;
//     return FutureBuilder(
//       future: _futureFunctions,
//       builder: (ctx, snapshot) => snapshot.connectionState ==
//               ConnectionState.waiting
//           // ? const Center(
//           //     child: CircularProgressIndicator(
//           //       backgroundColor: Colors.white,
//           //       color: Colors.black,
//           //     ),
//           //   )
//           ? LiteNftScreen()
//           : RefreshIndicator(
//               onRefresh: () => _updateNftParameters(ctx),
//               child: WillPopScope(
//                 onWillPop: () async => false,
//                 child: SingleChildScrollView(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   child: SizedBox(
//                     height: MediaQuery.of(context).size.height,
//                     child: DefaultTabController(
//                       length: 2,
//                       child: Scaffold(
//                         backgroundColor: Colors.black,
//                         drawer: AppDrawer(),
//                         appBar: AppBar(
//                           title: Text(
//                             'GrammIt',
//                           ),
//                           backgroundColor: Colors.blueGrey[600],
//                           actions: <Widget>[
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.monetization_on,
//                                 size: 24,
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context)
//                                     .pushNamed(WalletScreen.routeName);
//                               },
//                             ),
//                           ],

//                           elevation: 0,
//                           // give the app bar rounded corners
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(20.0),
//                               bottomRight: Radius.circular(20.0),
//                             ),
//                           ),
//                         ),
//                         body: Container(
//                           padding: EdgeInsets.only(left: 15, right: 15),
//                           child: Column(
//                             children: <Widget>[
//                               SizedBox(height: 25),
//                               // construct the profile details widget here
//                               SizedBox(
//                                 height: height * 0.44,
//                                 child: Center(
//                                   child: NftInfo(nftState, _rewardList),
//                                 ),
//                               ),

//                               Divider(),

//                               // the tab bar with two items
//                               SizedBox(
//                                 height: 25,
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 15, right: 15),
//                                   // decoration: BoxDecoration(
//                                   //   borderRadius: BorderRadius.circular(10),
//                                   // ),
//                                   child: TabBar(
//                                     //padding: EdgeInsets.only(left: 5, right: 5),
//                                     labelColor: Colors.white,
//                                     unselectedLabelColor: Colors.grey,
//                                     controller: _tabController,
//                                     indicatorColor: Colors.white,
//                                     isScrollable: true,
//                                     indicatorSize: TabBarIndicatorSize.label,
//                                     tabs: [
//                                       Tab(
//                                         text: 'CORE PROPERTIES',
//                                       ),
//                                       Tab(
//                                         text: 'NON-CORE PROPERTIES',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                               // create widgets for each tab bar here
//                               SizedBox(
//                                 height: 210,
//                                 child: TabBarView(
//                                   controller: _tabController,
//                                   children: [
//                                     // first tab bar view widget
//                                     Attribute_Nft(true, nftState, _rewardList),
//                                     Attribute_Nft(false, nftState, _rewardList),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   IconButton _buildIcon(IconData icon) {
//     return IconButton(
//       onPressed: () {},
//       icon: Icon(
//         icon,
//         color: Colors.black,
//         size: 18,
//       ),
//       splashRadius: 24,
//     );
//   }
// }

// // class CircleTabIndicator extends Decoration {
// //   final Color color;
// //   double radius;

// //   CircleTabIndicator({required this.color, required this.radius});
// //   @override
// //   BoxPainter createBoxPainter([VoidCallback? onChanged]) {
// //     return _CirclePainter(color: color, radius: radius);
// //   }
// // }

// // class _CirclePainter extends BoxPainter {
// //   final Color color;
// //   double radius;
// //   _CirclePainter({required this.color, required this.radius});
// //   @override
// //   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
// //     Paint _paint = Paint();
// //     _paint.color = color;
// //     _paint.isAntiAlias = true;
// //     final Offset circleOffset = Offset(
// //         configuration.size!.width / 2 - radius / 2,
// //         configuration.size!.height - radius);
// //     canvas.drawCircle(offset + circleOffset, radius, _paint);
// //   }
// // }
