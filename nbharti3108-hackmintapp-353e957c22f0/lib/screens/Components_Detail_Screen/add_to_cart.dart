// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/Product.dart';
import '../../providers/calculation_util.dart';

class AddToCart extends StatefulWidget {
  AddToCart(
      {required this.product,
      required this.noOfItems,
      required this.grammsNeeded});

  final Product product;
  final noOfItems;
  final grammsNeeded;

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  final kTextColor = Color(0xFF535353);

  final kTextLightColor = Color(0xFFACACAC);

  final kDefaultPaddin = 20.0;
  Future<void> callRewardListFromDatabase(BuildContext context) async {
    await Provider.of<CalculationUtil>(context, listen: false)
        .fetchRewardList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 50,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: widget.product.color,
                onPressed: () async {
                  await callRewardListFromDatabase(context);
                  if (widget.noOfItems > 0) {
                    final grammsAvailable =
                        Provider.of<CalculationUtil>(context, listen: false)
                            .totalGrammTokensAvailable;
                    if (grammsAvailable > widget.grammsNeeded) {
                      await Provider.of<ProductPurchaseByUser>(context,
                              listen: false)
                          .postItemPurchase(
                              productId: widget.product.id,
                              noOfItems: widget.noOfItems,
                              isWishlist: false,
                              placedOrder: true)
                          .then((_) async {
                        final upgradeTime =
                            DateTime.now().millisecondsSinceEpoch ~/ 1000;
                        await Provider.of<ProductPurchaseByUser>(context,
                                listen: false)
                            .postMarketplaceTransactionToFirebase(
                                widget.grammsNeeded, upgradeTime, false)
                            .then((_) async {
                          await callRewardListFromDatabase(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text(
                                  'Your order has been received. We will reach out to you!')));
                        });
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text(
                              'You do not have enough gramms! Keep programming.')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('Please select the number of items!')));
                  }
                },
                child: Text(
                  "Buy  Now".toUpperCase(),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
