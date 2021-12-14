// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/screens/product_details_screen.dart';
import 'package:grocery/widgets/cart/counter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;
  ProductCard(this.document);

  @override
  Widget build(BuildContext context) {
    String offer =
        ((document.data()['comparedPrice'] - document.data()['price']) /
                document.data()['comparedPrice'] *
                100)
            .toStringAsFixed(0);

    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      pushNewScreenWithRouteSettings(context,
                          settings:
                              RouteSettings(name: ProductDetailsScreen.id),
                          screen: ProductDetailsScreen(document: document),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    child: SizedBox(
                      height: 140,
                      width: 130,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: 'product${document.data()['productName']}',
                            child: Image.network(
                              document.data()['productImage'],
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ),
                ),
                if (document.data()['comparedPrice'] >
                    0) //Show only when offer is available
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 3, bottom: 3),
                      child: Text(
                        '$offer %OFF',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(document.data()['brand'],
                            style: TextStyle(fontSize: 10)),
                        SizedBox(height: 6),
                        Text(document.data()['productName'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Container(
                            width: MediaQuery.of(context).size.width - 160,
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[200]),
                            child: Text(document.data()['weight'],
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]))),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                                '\$${document.data()['price'].toStringAsFixed(0)}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            if (document.data()['comparedPrice'] >
                                0) //Only if it has a value of more than 0
                              Text(
                                '\$${document.data()['comparedPrice'].toStringAsFixed(0)}',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CounterForCard(document),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
