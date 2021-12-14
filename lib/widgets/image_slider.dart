// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _dataLength = 1;
  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }

  Future getSliderImageFromDb() async {
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _fireStore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          FutureBuilder(
            future: getSliderImageFromDb(),
            builder: (_, AsyncSnapshot snapShot) {
              return snapShot.data == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CarouselSlider.builder(
                          itemCount: snapShot.data.length,
                          itemBuilder: (BuildContext context, int add, int i) {
                            DocumentSnapshot sliderImage = snapShot.data[add];
                            Map getImage = sliderImage.data();
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.network(
                                    getImage['image'],
                                    fit: BoxFit.fill,
                                  )),
                            );
                          },
                          options: CarouselOptions(
                              viewportFraction: 1,
                              initialPage: 0,
                              autoPlay: true,
                              height: 150,
                              onPageChanged:
                                  (int i, carouselPageChangedReason) {
                                setState(() {
                                  _index = i;
                                });
                              })),
                    );
            },
          ),
          if (_dataLength != 0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  activeColor: Theme.of(context).primaryColor),
            ),
        ],
      ),
    );
  }
}
