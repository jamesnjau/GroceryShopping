// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/screens/product_list_screen.dart';
import 'package:grocery/services/product_services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _services = ProductServices();

  List _catList = [];
  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _catList.add(doc['category']['mainCategory']);
                });
              })
            });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);

    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('something went wrong'));
        }
        if (_catList.length == 0) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/city.png'))),
                    child: Center(
                      child: Text(
                        'Shop by category',
                        style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black)
                          ],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return _catList.contains(document.data()['name'])
                      ?
                      //only if _catlist contains the category name from selected vendor
                      InkWell(
                          onTap: () {
                            _store.selectedCategory(document.data()['name']);
                            _store.selectedCategorySub(null);
                            pushNewScreenWithRouteSettings(context,
                                settings:
                                    RouteSettings(name: ProductListScreen.id),
                                screen: ProductListScreen(),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          },
                          child: Container(
                            width: 120,
                            height: 150,
                            padding: EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey, width: .5)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child:
                                        Image.network(document.data()['image']),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      document.data()['name'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text('');
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
