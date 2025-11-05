import 'package:first_app/widgets/itemcard_marketplace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../providers/Product.dart';

class ShopScreen extends StatefulWidget {
  static const routeName = '/shop-screen';

  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final kTextColor = Color(0xFF535353);

  final kTextLightColor = Color(0xFFACACAC);

  final kDefaultPaddin = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: buildAppBar(),
        body: Column(children: [
          SizedBox(height: 50),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: kDefaultPaddin,
                  childAspectRatio: 0.75),
              itemBuilder: (context, index) =>
                  ItemCard(product: products[index]),
            ),
          )),
        ]));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Marketplace'),
      backgroundColor: Colors.blueGrey[600],
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }
}
