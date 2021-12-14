import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
    cart.doc(user.uid).set({
      'user': user.uid,
      'sellerUid': document.data()['seller'][
          'sellerUid'], // remove this if you want to add from deferent sellers detail from here
      'shopName': document.data()['seller']['shopName'], // seller detail
    });

    return cart.doc(user.uid).collection('products').add({
      'productId': document.data()['productId'],
      'productName': document.data()['productName'],
      'productImage': document.data()['productImage'],
      'weight': document.data()['weight'],
      'price': document.data()['price'],
      'comparedPrice': document.data()['comparedPrice'],
      'sku': document.data()['sku'],
      'qty': 1,
      'total': document.data()['price'], // price for 1 qty
      //  'sellerUid': document.data()['seller']['sellerUid'], // uncommetn this if you want to add from deferent sellers detail from here
      // 'shopName': document.data()['seller']['shopName'],  // seller detail
    });
  }

  Future<void> updateCartQty(docId, qty, total) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .doc(docId);

    FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception('Product does not exist in cart');
          }
          transaction.update(documentReference, {'qty': qty, 'total': total});

          return qty;
        })
        .then((value) => print('Update Cart'))
        .catchError((error) => print('Failed to update cart: $error'));
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user.uid).collection('products').doc(docId).delete();
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user.uid).delete();
    }
  }

  Future<void> deleteCart() async {
    final result =
        await cart.doc(user.uid).collection('products').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future checkSeller() async {
    final snapshot = await cart.doc(user.uid).get();
    return snapshot.exists ? snapshot.data()['shopName'] : null;
  }
}
