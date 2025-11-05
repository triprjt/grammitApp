import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../providers/Product.dart';
import '../screens/Components_Detail_Screen/body.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  final kDefaultPaddin = 20.0;

  ProductDetailsScreen({required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: product.color,
      appBar: buildAppBar(context),
      body: Body(
        product: product,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color,
      elevation: 4,
    );
  }
}
