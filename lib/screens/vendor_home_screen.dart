import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/widgets/categories_widget.dart';
import 'package:grocery/widgets/products/best_selling_product.dart';
import 'package:grocery/widgets/products/featured_products.dart';
import 'package:grocery/widgets/products/recently_added_products.dart';
import 'package:grocery/widgets/vendor_app_bar.dart';
import 'package:grocery/widgets/vendor_banner.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [VendorAppBar()];
            },
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                VendorBanner(),
                VendorCategories(),
                //Recently Added Product
                //Best Selling Products
                //Featured Products
                RecentlyAddedProducts(),
                FeaturedProducts(),
                BestSellingProduct(),
              ],
            )));
  }
}
