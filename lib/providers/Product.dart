import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Product {
  final String image, title, description;
  final int price, id;
  final Color color;
  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.color,
  });
}

List<Product> products = [
  Product(
    id: 1,
    title: "APPLE iPHONE 12",
    price: 9999,
    description:
        "Apple iPhone 12 (64 GB). Memory: 4GB RAM, 64GB ROM. Camera: 12MP",
    image: "assets/images/iphone.png",
    color: Color(0xFFFB7883),
  ),
  Product(
    id: 2,
    title: "APPLE iPAD 9th Gen",
    price: 4999,
    description:
        "Apple iPad 9th Gen (64 GB). 10.2 inch screen. 12MP Camera. 10hrs battery.",
    image: "assets/images/iPad.png",
    color: Color(0xFFAEAEAE),
  ),
  Product(
      id: 3,
      title: "ZEBRONICS KEYBOARD",
      price: 125,
      description:
          "ZEBRONICS Zeb-K20 Wired USB Desktop Keyboard  (Black). This keyboard comes with special Key type with Rupee Key (Black)",
      image: "assets/images/Zebronics_keyboard.png",
      color: Color(0xFF3D82AE)),
  Product(
      id: 4,
      title: "LOGITECH COMBO",
      price: 299,
      description:
          "Logitech MK270r Wireless Combo Keyboard  (Black). The keyboard comes with 8 hot keys so you can easily access the media controls and other shortcuts. Also, the compact size of the mouse lets you carry it along in your travel bag with ease.",
      image: "assets/images/logitech_wireless_combo.png",
      color: Color(0xFFD3A984)),
  Product(
      id: 5,
      title: "LOGITECH WIRELESS MOUSE",
      price: 199,
      description:
          "Logitech B175 / Optical Tracking, 12-Months Battery Life, Ambidextrous Wireless Optical Mouse  (2.4GHz Wireless, Black)",
      image: "assets/images/logitech_wireless.png",
      color: Color(0xFF989493)),
  Product(
      id: 6,
      title: "HP WIRELESS MOUSE",
      price: 99,
      description:
          "HP S500 Wireless Optical Mouse  (2.4GHz Wireless, Black). System Requirements: Windows 7, Mac OS,Windows 8, Windows 10",
      image: "assets/images/hp_wireless_mouse.png",
      color: Color(0xFFE6B398)),
  Product(
      id: 7,
      title: "OFFICE DESKTOP",
      price: 1499,
      description:
          "Designed to power you through entertainment, study and working at home, Lenovo D22e-20 is the answer. 21.45-inch VA panel display with 178°/178° view angle delivers quality visuals whichever way you look at it",
      image: "assets/images/lenovo_monitor.png",
      color: Color(0xFFFB7883)),
  Product(
    id: 8,
    title: "COOLING PAD",
    price: 249,
    description:
        "LAPCARE LE_Colling Pad-4 2 Fan Cooling Pad  (Black). One of the most versatile and elegant looking laptop cooling stand that reduces working fatigue for long hours of laptop working. Its 2 usb ports and a slick cable manager makes working on the laptop much convenient, faster and efficient.",
    image: "assets/images/cooling_pad.png",
    color: Color(0xFFAEAEAE),
  ),
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";

class ProductPurchaseByUser with ChangeNotifier {
  // This method should be called only after there are sufficient number of gramms

  Future<void> postItemPurchase(
      {required int productId,
      required int noOfItems,
      required bool isWishlist,
      required bool placedOrder}) async {
    final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/marketPlace.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      await http.post(
        url,
        body: json.encode(
          {
            'userId': _userId,
            'productId': productId,
            'noOfItems': noOfItems,
            'isWishlist': isWishlist,
            'placedOrder': placedOrder
          },
        ),
      );
      print('data added successfully');
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> postMarketplaceTransactionToFirebase(
      int scoreOrGrammToken, int upgradeTime, bool isScore) async {
    final url = Uri.https(
        'grammit-70261-default-rtdb.firebaseio.com',
        '/rewardList.json',
        {'auth': 'O1uf89CMRqd5OtxXCvQMdH296hcBZcPXnN5RDx9k'});
    const storage = FlutterSecureStorage();
    try {
      String? _userId = await storage.read(key: "uid");
      await http.post(
        url,
        body: json.encode(
          {
            // 'totalScore': -1,
            'lastScoreGained': isScore ? -scoreOrGrammToken : -1,
            'grammToken': isScore ? -1 : -scoreOrGrammToken,
            // 'totalGrammToken': -1,
            'lastRewardedTime': upgradeTime,
            'userId': _userId,
            // 'numOfCorrectSubmissions': -1,
            // 'totalNumOfSubmissions': -1,
            'platform': "marketplace",
          },
        ),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
