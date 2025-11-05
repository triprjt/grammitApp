import 'dart:convert';

import 'package:first_app/providers/calculation_util.dart';
import 'package:first_app/providers/challenges_provider.dart';
import 'package:first_app/providers/linkAccount.dart';
import 'package:first_app/providers/session_provider.dart';
import 'package:first_app/screens/challenges_screen.dart';
import 'package:first_app/screens/create_wallet_screen.dart';
import 'package:first_app/screens/learn_more_screen.dart';
import 'package:first_app/screens/linkAccountScreen.dart';
import 'package:first_app/screens/link_account_appDrawer_screen.dart';
// import 'package:first_app/screens/lite_nft_screen.dart';
import 'package:first_app/screens/mint_nft_screen.dart';
import 'package:first_app/screens/minted_nft_screen.dart';
import 'package:first_app/screens/pair_programming_screen.dart';
import 'package:first_app/screens/reward_refresh_screen.dart';
import 'package:first_app/screens/session_screen.dart';
import 'package:first_app/screens/shop_screen.dart';
import 'package:first_app/screens/toggle_screen.dart';
import 'package:first_app/screens/wallet_created_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import './screens/nftScreen.dart';
import 'providers/email_auth_provider.dart';
import './providers/create_wallet.dart';
import './providers/Product.dart';
import './screens/bottom_navigation_bar_screen.dart';
import './screens/rewards_screen.dart';
import './screens/wallet_screen.dart';
import './providers/calculation_util.dart';
import './screens/google_login_screen.dart';
import './screens/login_with_share_code_screen.dart';
import './screens/product_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  Future<bool> checkLoginStatus() async {
    try {
      String? uidPresent = await storage.read(key: "uid");
      // await storage.deleteAll();

      if (uidPresent == null) {
        return false;
      }
      return true;
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => LinkAccount(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CreateWallet(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CalculationUtil(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SessionProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ChallengesProvider(),
        ),
        ChangeNotifierProvider(create: (ctx) => GoogleSignInProvider()),
        ChangeNotifierProvider(
          create: (ctx) => ProductPurchaseByUser(),
        ),
      ],
      child: MaterialApp(
        title: 'GrammIT',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.amber),
          fontFamily: 'Lato',
        ),
        home: FutureBuilder(
          future: checkLoginStatus(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == false) {
              return SignInPage();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ToggleScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          //PhoneAuthScreen.routeName: (ctx) => PhoneAuthScreen(),
          LinkAccountScreen.routeName: (ctx) => LinkAccountScreen(),
          // NftScreen.routeName: (ctx) => NftScreen(),
          // CreateWalletScreen.routeName: (ctx) => CreateWalletScreen(),
          // WalletCreatedScreen.routeName: (ctx) => WalletCreatedScreen(),
          // MintNftScreem.routeName: (ctx) => MintNftScreem(),
          // MintedNftScreen.routeName: (ctx) => MintedNftScreen(),
          ToggleScreen.routeName: (ctx) => ToggleScreen(),
          BottomNavScreen.routeName: (ctx) => BottomNavScreen(false),
          BottomNavScreen.routeName2: (ctx) => BottomNavScreen(true),
          RewardsScreen.routeName: (ctx) => RewardsScreen(),
          // WalletScreen.routeName: (ctx) => WalletScreen(),
          SignInPage.routeName: (ctx) => SignInPage(),
          LearnMoreScreen.routeName: (ctx) => LearnMoreScreen(),
          SignInWithSharePage.routeName: (ctx) => SignInWithSharePage(),
          LinkAccountAppDrawerScreen.routeName: (ctx) =>
              LinkAccountAppDrawerScreen(),
          // LiteNftScreen.routeName: (ctx) => LiteNftScreen(),
          SessionScreen.routeName: (ctx) => SessionScreen(),
          ShopScreen.routeName: (ctx) => ShopScreen(),
          RewardsRefreshScreen.routeName: (ctx) => RewardsRefreshScreen(),
          ChallengesScreen.routeName: (ctx) => ChallengesScreen(),
          PairProgrammingScreen.routeName: (ctx) => PairProgrammingScreen(),
        },
      ),
    );
  }
}
