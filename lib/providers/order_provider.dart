import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  String? status;
  int? amount;
  bool success = false;
  String? shopName;
  String? email;

  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }

  totalAmount(amount, shopName, email) {
    this.amount = amount;
    this.shopName = shopName;
    this.email = email;
    notifyListeners();
  }

  paymentStatus(success) {
    this.success = success;
    notifyListeners();
  }
}
