import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPaymentScreen extends StatefulWidget {
  static const String id = 'razor-pay';
  @override
  _RazorPaymentScreenState createState() => _RazorPaymentScreenState();
}

class _RazorPaymentScreenState extends State<RazorPaymentScreen> {
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;
  bool? success;

  Future<void> openCheckout(OrderProvider orderProvider) async {
    User user = FirebaseAuth.instance.currentUser;
    PaymentSuccessResponse? response;

    var options = {
      'key': 'rzp_test_', //TODO: Give your own api key
      'amount': '${orderProvider.amount}00',
      'name': orderProvider.shopName,
      'description': 'Grocery Purchase',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': user.phoneNumber, 'email': orderProvider.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      success = true;
    });
    // EasyLoading.show(status: "SUCCESS: " + response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.show(
        status:
            "ERROR: " + response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    EasyLoading.show(status: "EXTERNAL_WALLET: " + response.walletName!);
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Pay using Razorpay',
            style: TextStyle(color: Colors.white)),
      ),
      body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Column(
              children: [
                Text(
                  'Total Amount to Pay:  \n\$${orderProvider.amount}',
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    )),
                    onPressed: () {
                      openCheckout(orderProvider).whenComplete(() {
                        if (success = true) {
                          orderProvider.paymentStatus(true);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )
          ])),
    );
  }
}
