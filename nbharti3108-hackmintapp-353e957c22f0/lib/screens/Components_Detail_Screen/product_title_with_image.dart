import 'package:flutter/material.dart';
import '../../providers/Product.dart';

class ProductTitleWithImage extends StatelessWidget {
  ProductTitleWithImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  final kTextColor = Color(0xFF535353);

  final kTextLightColor = Color(0xFFACACAC);

  final kDefaultPaddin = 20.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            product.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 5,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "PRICE: ",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextSpan(
                  text: (product.price).toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: kTextColor,
                  ),
                ),
                TextSpan(
                  text: " GRAMMS",
                  style: TextStyle(fontSize: 15, color: kTextColor),
                ),
              ],
            ),
          ),
          SizedBox(height: kDefaultPaddin * 1.2),
          Row(
            children: <Widget>[
              SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: "${product.id}",
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.fill,
                    height: 310,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
