// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:first_app/screens/challenges_screen.dart';
import 'package:first_app/screens/pair_programming_screen.dart';
import 'package:first_app/screens/session_screen.dart';
import 'package:first_app/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/create_wallet.dart';
import 'nftScreen.dart';
import 'rewards_screen.dart';

class BottomNavScreen extends StatefulWidget {
  static const routeName = '/bottom-nav-screen';
  static const routeName2 = '/bottom-nav-screen2';
  // const BottomNavScreen({Key? key}) : super(key: key);
  bool rewardRefreshFlag;
  BottomNavScreen([this.rewardRefreshFlag = false]);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with AutomaticKeepAliveClientMixin<BottomNavScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<CreateWallet>(context, listen: false).setPageIndexToDevice(1);
    });
    super.initState();
  }

  int index = 0;

  final screens = [
    // NftScreen(),
    ChallengesScreen(),
    RewardsScreen(),
    PairProgrammingScreen(),
    SessionScreen(),
    ShopScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    if (widget.rewardRefreshFlag) {
      index = 1;
    }
    super.build(context); // need to call super method.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        /*
        commented code can be used when we don't want the page to reload on changing tabs. 
        But with nft screen optimization, we are good to reload 
        */
        // body: IndexedStack(
        //   index: index,
        //   children: [screens[0], screens[1], screens[2], screens[3]],
        // ),
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
              height: 60,
              backgroundColor: Colors.blueGrey[400],
              // labelBehavior:
              // NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: const Duration(seconds: 1),
              selectedIndex: index,
              onDestinationSelected: (index) => setState(() {
                    this.index = index;
                    widget.rewardRefreshFlag = false;
                    // print("set state in bottom nav bar");
                    // print(index);
                  }),
              destinations: const [
                // NavigationDestination(
                //     icon: Icon(
                //       Icons.home_outlined,
                //       size: 27,
                //     ),
                //     selectedIcon: Icon(
                //       Icons.home,
                //       size: 27,
                //     ),
                //     label: ''),
                NavigationDestination(
                  icon: Icon(
                    Icons.code_outlined,
                    size: 27,
                  ),
                  selectedIcon: Icon(
                    Icons.code,
                    size: 27,
                  ),
                  label: 'Code',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.emoji_events_outlined,
                    size: 27,
                  ),
                  selectedIcon: Icon(
                    Icons.emoji_events,
                    size: 27,
                  ),
                  label: 'Rewards',
                ),
                NavigationDestination(
                  icon: Icon(
                    // FontAwesomeIcons.teamspeak,
                    Icons.group_outlined,
                    size: 27,
                  ),
                  selectedIcon: Icon(
                    // FontAwesomeIcons.teamspeak,
                    // color: Colors.black,
                    Icons.group,
                    size: 27,
                  ),
                  label: 'Pair',
                ),
                NavigationDestination(
                  icon: Icon(
                    // FontAwesomeIcons.teamspeak,
                    Icons.rate_review_outlined,
                    size: 27,
                  ),
                  selectedIcon: Icon(
                    // FontAwesomeIcons.teamspeak,
                    // color: Colors.black,
                    Icons.rate_review,
                    size: 27,
                  ),
                  label: 'CV',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.shopping_cart_checkout_outlined,
                    size: 27,
                  ),
                  selectedIcon: Icon(
                    Icons.shopping_cart,
                    size: 27,
                  ),
                  label: 'Shop',
                ),
              ]),
        ),
      ),
    );
  }
}
