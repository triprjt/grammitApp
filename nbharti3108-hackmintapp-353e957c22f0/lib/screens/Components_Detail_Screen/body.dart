// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../providers/Product.dart';

import 'add_to_cart.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'description.dart';
import 'product_title_with_image.dart';

class Body extends StatefulWidget {
  final Product product;

  Body({required this.product});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int numOfItems = 0;

  final kTextColor = Color(0xFF535353);

  final kTextLightColor = Color(0xFFACACAC);

  final kDefaultPaddin = 20.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.4),
                  padding: EdgeInsets.only(
                    top: size.height * 0.1,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: kDefaultPaddin / 2),
                      Description(product: widget.product),
                      SizedBox(height: kDefaultPaddin / 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              buildOutlineButton(
                                icon: Icons.remove,
                                press: () {
                                  if (numOfItems > 0) {
                                    setState(() {
                                      numOfItems--;
                                    });
                                  }
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kDefaultPaddin / 2),
                                child: Text(
                                  // if our item is less  then 10 then  it shows 01 02 like that
                                  numOfItems.toString().padLeft(2, "0"),
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              buildOutlineButton(
                                  icon: Icons.add,
                                  press: () {
                                    setState(() {
                                      numOfItems++;
                                    });
                                  }),
                            ],
                          ),
                          RichText(
                            maxLines: 1,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "GRAMMS NEEDED:  ",
                                    style: TextStyle(
                                        color: widget.product.color,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: (numOfItems * widget.product.price)
                                        .toString(),
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kDefaultPaddin / 2),
                      AddToCart(
                        product: widget.product,
                        noOfItems: numOfItems,
                        grammsNeeded: numOfItems * widget.product.price,
                      )
                    ],
                  ),
                ),
                ProductTitleWithImage(product: widget.product)
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox buildOutlineButton(
      {required IconData icon, required VoidCallback press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }
}
