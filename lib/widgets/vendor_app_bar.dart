// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/models/product_model.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/screens/product_details_screen.dart';
import 'package:grocery/widgets/cart/counter.dart';
import 'package:grocery/widgets/search_card.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:map_launcher/map_launcher.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:url_launcher/url_launcher.dart';

class VendorAppBar extends StatefulWidget {
  @override
  _VendorAppBarState createState() => _VendorAppBarState();
}

class _VendorAppBarState extends State<VendorAppBar> {
  static List<Product> products = [];
  String offer = '';
  String shopName = '';
  DocumentSnapshot? document;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          document = doc;
          offer = ((doc.data()['comparedPrice'] - doc.data()['price']) /
                  doc.data()['comparedPrice'] *
                  100)
              .toStringAsFixed(0);

          products.add(Product(
              brand: doc['brand'],
              comparedPrice: doc['comparedPrice'],
              weight: doc['weight'],
              category: doc['category']['mainCategory'],
              image: doc['productImage'],
              price: doc['price'],
              productName: doc['productName'],
              shopName: doc['seller']['shopName'],
              document: doc));
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    products.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);

    mapLauncher() async {
      GeoPoint location = _store.storeDetails['location'];
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: '${_store.storeDetails['shopName']} is here',
      );
    }

    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme: IconThemeData(color: Colors.white),
      expandedHeight: 260,
      flexibleSpace: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 86),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_store.storeDetails['imageUrl']),
                  ),
                ),
                child: Container(
                  color: Colors.grey.withOpacity(.7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Text(
                          _store.storeDetails['dialog'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(_store.storeDetails['address'],
                            style: TextStyle(color: Colors.white)),
                        Text(_store.storeDetails['email'],
                            style: TextStyle(color: Colors.white)),
                        Text('Distance: ${_store.distance} km',
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star_half,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star_outline,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '(3.5)',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  icon: Icon(Icons.phone,
                                      color: Theme.of(context).primaryColor),
                                  onPressed: () {
                                    launch(
                                        'tel: ${_store.storeDetails['mobile']}');
                                  }),
                            ),
                            SizedBox(width: 3),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(
                                  Icons.map,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  mapLauncher();
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              shopName = _store.storeDetails['shopName'];
            });
            var searchPage = SearchPage<Product>(
              onQueryUpdate: (s) => print(s),
              items: products,
              searchLabel: 'Search Product',
              suggestion: Center(
                  child: Text('Filter product by name, category or price ')),
              failure: Center(child: Text('No product found')),
              filter: (product) => [
                product.productName!,
                product.category!,
                product.brand!,
                product.price!.toString(),
                //this are the fields search will happen
              ],
              builder: (product) => shopName != product.shopName
                  ? Container()
                  : SearchCard(
                      offer: offer,
                      product: product,
                      document: product.document!),
            );
            showSearch(
              context: context,
              delegate: searchPage,
            );
          },
          icon: Icon(CupertinoIcons.search),
        )
      ],
      title: Text(
        _store.storeDetails['shopName'],
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
