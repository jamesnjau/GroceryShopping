import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery/providers/order_provider.dart';
import 'package:grocery/screens/payment/razorpay/razorpay_payment_screen.dart';
import 'package:grocery/screens/payment/stripe/existing-cards.dart';
import 'package:grocery/services/payment/create_new_card_screen.dart';
import 'package:grocery/services/payment/stripe_payment_service.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_stripe_payments/services/payment-service.dart';
// import 'package:progress_dialog/progress_dialog.dart';b

class PaymentHome extends StatefulWidget {
  static const String id = 'stripe-home';
  PaymentHome({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<PaymentHome> {
  onItemPress(BuildContext context, int index, amount, orderProvider) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, CreateNewCreditCard.id);
        break;
      case 1:
        payViaNewCard(context, amount, orderProvider);
        break;
      case 2:
        Navigator.pushNamed(context, ExistingCardsPage.id);
        break;
    }
  }

  payViaNewCard(
      // change to country name
      BuildContext context,
      amount,
      OrderProvider orderProvider) async {
    await EasyLoading.show(status: 'Please wait...');
    var response = await StripeService.payWithNewCard(
      amount: '${amount}00', // bring amount from cart total
      currency: 'KES', // change to country name
    );

    if (orderProvider.success == true) {
      orderProvider.success = true;
    }
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https:stripe.com/img/v3/newsroom/social.png',
                    fit: BoxFit.fill,
                  ),
                )),
          ), // stripe logo
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 40, right: 40),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: () {
                        Navigator.pushNamed(context, RazorPaymentScreen.id);
                      },
                      child: Text('Proceed to payment')),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey),
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https:stripe.com/img/v3/newsroom/social.png',
                    fit: BoxFit.fill,
                  ),
                )),
          ), // stripe logo
          //TODO: Paypal
          Divider(color: Colors.grey),
          Material(
            elevation: 4,
            child: SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.network(
                    'https:stripe.com/img/v3/newsroom/social.png',
                    fit: BoxFit.fill,
                  ),
                )),
          ), // stripe logo
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Icon icon = Icon(Icons.add_circle);
                  Text text = Text('');

                  switch (index) {
                    case 0:
                      icon = Icon(Icons.add_circle, color: theme.primaryColor);
                      text = Text('Add cards');
                      //TODO: add new cards to firestore
                      break;
                    case 1:
                      icon = Icon(Icons.payment_outlined,
                          color: theme.primaryColor);
                      text = Text('Pay via new card');
                      break;
                    case 2:
                      icon = Icon(Icons.credit_card, color: theme.primaryColor);
                      text = Text('Pay via existing card');
                      break;
                  }

                  return InkWell(
                    onTap: () {
                      onItemPress(
                          context, index, orderProvider.amount, orderProvider);
                    },
                    child: ListTile(
                      title: text,
                      leading: icon,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      color: theme.primaryColor,
                    ),
                itemCount: 3),
          ),
        ],
      ),
    );
  }
}
