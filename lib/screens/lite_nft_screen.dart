// import 'package:async/async.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../providers/calculation_util.dart';
// import '../widgets/nft_attribues.dart';
// import 'package:flutter/material.dart';
// import '../providers/nft_provier.dart';
// import '../widgets/nft_info.dart';
// import '../widgets/app_drawer.dart';
// import '../providers/linkAccount.dart';
// import 'package:provider/provider.dart';
// import '../screens/wallet_screen.dart';

// class LiteNftScreen extends StatefulWidget {
//   const LiteNftScreen({Key? key}) : super(key: key);
//   static const routeName = '/liteNft-screen';

//   @override
//   State<LiteNftScreen> createState() => _LiteNftScreenState();
// }

// class _LiteNftScreenState extends State<LiteNftScreen>
//     with TickerProviderStateMixin {
//   late Future<void> _liteFutureFunctions;
//   Map<String, int> nftState = {};
//   List<RewardItem> _rewardList = [];

//   @override
//   void initState() {
//     _liteFutureFunctions = _getNftParameters(context);
//     super.initState();
//   }

//   Future<void> _getNftParameters(BuildContext context) async {
//     print("... running lite nft functions .....");
//     await Provider.of<LinkAccount>(context, listen: false).fetchNftState(true);
//     await Provider.of<CalculationUtil>(context, listen: false)
//         .fetchRewardList();
//     nftState = Provider.of<LinkAccount>(context, listen: false).liteNftState;
//     _rewardList =
//         Provider.of<CalculationUtil>(context, listen: false).rewardList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     TabController _tabController = TabController(length: 2, vsync: this);
//     double height = MediaQuery.of(context).size.height;
//     return FutureBuilder(
//       future: _liteFutureFunctions,
//       builder: (ctx, snapshot) => snapshot.connectionState ==
//               ConnectionState.waiting
//           ? const Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.white,
//                 color: Colors.black,
//               ),
//             )
//           : WillPopScope(
//               onWillPop: () async => false,
//               child: SingleChildScrollView(
//                 physics: AlwaysScrollableScrollPhysics(),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   child: DefaultTabController(
//                     length: 2,
//                     child: Scaffold(
//                       backgroundColor: Colors.black,
//                       drawer: AppDrawer(),
//                       appBar: AppBar(
//                         title: const Text(
//                           'GrammIt',
//                         ),
//                         backgroundColor: Colors.blueGrey[600],
//                         actions: <Widget>[
//                           IconButton(
//                             icon: const Icon(
//                               Icons.monetization_on,
//                               size: 24,
//                             ),
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .pushNamed(WalletScreen.routeName);
//                             },
//                           ),
//                         ],

//                         elevation: 0,
//                         // give the app bar rounded corners
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(20.0),
//                             bottomRight: Radius.circular(20.0),
//                           ),
//                         ),
//                       ),
//                       body: Container(
//                         padding: EdgeInsets.only(left: 15, right: 15),
//                         child: Column(
//                           children: <Widget>[
//                             SizedBox(height: 25),
//                             // construct the profile details widget here
//                             SizedBox(
//                               height: height * 0.44,
//                               child: Center(
//                                 child: NftInfo(nftState, _rewardList),
//                               ),
//                             ),

//                             Divider(),

//                             // the tab bar with two items
//                             SizedBox(
//                               height: 25,
//                               child: Container(
//                                 padding: EdgeInsets.only(left: 15, right: 15),
//                                 // decoration: BoxDecoration(
//                                 //   borderRadius: BorderRadius.circular(10),
//                                 // ),
//                                 child: TabBar(
//                                   //padding: EdgeInsets.only(left: 5, right: 5),
//                                   labelColor: Colors.white,
//                                   unselectedLabelColor: Colors.grey,
//                                   controller: _tabController,
//                                   indicatorColor: Colors.white,
//                                   isScrollable: true,
//                                   indicatorSize: TabBarIndicatorSize.label,
//                                   tabs: const [
//                                     Tab(
//                                       text: 'CORE PROPERTIES',
//                                     ),
//                                     Tab(
//                                       text: 'NON-CORE PROPERTIES',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             // create widgets for each tab bar here
//                             SizedBox(
//                               height: 210,
//                               child: TabBarView(
//                                 controller: _tabController,
//                                 children: [
//                                   // first tab bar view widget
//                                   Attribute_Nft(true, nftState, _rewardList),
//                                   Attribute_Nft(false, nftState, _rewardList),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
