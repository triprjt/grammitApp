import 'package:flutter/material.dart';
import '../providers/Product.dart';
import '../screens/product_details_screen.dart';

class ItemCard extends StatelessWidget {
  final Product product;

  ItemCard({
    required this.product,
  });
  final kTextColor = Color(0xFF535353);

  final kTextLightColor = Color(0xFFACACAC);

  final kDefaultPaddin = 20.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
            ),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
                child: Text(
                  // products is out demo list
                  product.title,
                  style: TextStyle(color: kTextLightColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
                child: Text(
                  (product.price).toString() + ' GRAMMS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: Container(
              //padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              height: 40,
              // width: 160,
              decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.asset(product.image),
              ),
            ),
          ),
          SizedBox(height: 5),
          Divider(
            thickness: 0.5,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
