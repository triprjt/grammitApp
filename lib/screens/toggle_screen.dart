import 'dart:convert';
import 'package:first_app/screens/linkAccountScreen.dart';
import 'package:http/http.dart' as http;
import 'package:first_app/screens/create_wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/nftScreen.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/create_wallet.dart';
import '../screens/wallet_created_screen.dart';
import '../screens/mint_nft_screen.dart';
import '../screens/bottom_navigation_bar_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ToggleScreen extends StatefulWidget {
  static const routeName = '/toggle-screen';

  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  int? index;
  late Future<void> _pageIndexFuture;

  @override
  void initState() {
    _pageIndexFuture = _getPageIndex();
    super.initState();
  }

  Future<void> _getPageIndex() async {
    print("::::");
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      var _params = <String, String>{
        'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k',
        'orderBy': json.encode('userId'),
        'equalTo': json.encode(_userId),
      };
      final url = Uri.https('grammit-70261-default-rtdb.firebaseio.com',
          '/pageIndex.json', _params);

      final response = await http.get(url);
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData == null || extractedData.isEmpty) {
        await Provider.of<CreateWallet>(context, listen: false)
            .setPageIndexToDevice(0);
        index = 0;
        return;
      }
      extractedData.forEach((key, pageInfo) {
        index = pageInfo['index'];
      });

      // // await prefs.remove();
      // // await prefs.remove('userCodingData');
      // await prefs.clear();
      // if (!prefs.containsKey(_userId!)) {
      //   index = 0;
      // }
      // print(prefs.getString(_userId)!);
      // final extractedPageIndex = json.decode(prefs.getString(_userId)!);
      // index = extractedPageIndex['index'];
      // print(index);
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> _getUserWalletData() async {
    //   try {
    //     await Provider.of<CreateWallet>(context, listen: false)
    //         .getUserDataFromDB();
    //   } catch (error) {
    //     throw error;
    //   }
    // }

    return FutureBuilder(
        future: _pageIndexFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.white,
            ));
          } else {
            // print(index);
            if (index == 0) {
              return LinkAccountScreen();
            }
            // else if (index == 1) {
            //   return FutureBuilder(
            //     future: _getUserWalletData(),
            //     builder: (ctx, snapshot) =>
            //         snapshot.connectionState == ConnectionState.waiting
            //             ? const Center(
            //                 child: CircularProgressIndicator(),
            //               )
            //             : WalletCreatedScreen(),
            //   );
            // } else if (index == 2) {
            //   return FutureBuilder(
            //     future: _getUserWalletData(),
            //     builder: (ctx, snapshot) =>
            //         snapshot.connectionState == ConnectionState.waiting
            //             ? const Center(
            //                 child: CircularProgressIndicator(),
            //               )
            //             : MintNftScreem(),
            //   );
            // }
            else {
              return BottomNavScreen();
            }
          }
        });
  }
}
