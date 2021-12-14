// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/services/product_services.dart';
import 'package:grocery/widgets/products/product_card_widget.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class RecentlyAddedProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);

    return FutureBuilder<QuerySnapshot>(
        future: _services.products
            .where('published', isEqualTo: true)
            .where('collection', isEqualTo: 'Recently Added')
            .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('something went wrong');
          }
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(); // If no data
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 46,
                    decoration: BoxDecoration(
                        color: Colors.teal[100],
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text(
                        'Recently Added',
                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black)
                          ],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return new ProductCard(document);
                }).toList(),
              ),
            ],
          );
        });
  }
}
