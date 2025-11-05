// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../../providers/Product.dart';

class Description extends StatelessWidget {
  final Product product;
  // ignore: use_key_in_widget_constructors
  Description({
    required this.product,
  });

  final kDefaultPaddin = 20.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        product.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
