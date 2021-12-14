import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery/services/payment/stripe_payment_service.dart';

class CreateNewCreditCard extends StatefulWidget {
  static const String id = 'create-card';
  @override
  State<StatefulWidget> createState() => CreateNewCreditCardState();
}

class CreateNewCreditCardState extends State<CreateNewCreditCard> {
  StripeService _stripeService = StripeService();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Credit Card', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumberDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                      ),
                      expiryDateDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Expiry Date',
                        hintText: 'xx/xx',
                      ),
                      cvvCodeDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'CVV',
                        hintText: 'xxx',
                      ),
                      cardHolderDecoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff1b447b)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          'Validate',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'halter',
                            fontSize: 14,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          EasyLoading.show(status: 'Please wait...');
                          // List cards = [
                          //   {
                          //     'cardNumber': '4242424242424242',
                          //     'expiryDate': '04/24',
                          //     'cardHolderName': 'Jam Dev',
                          //     'cvvCode': '424',
                          //     'showBackView': false,
                          //     'uid': _stripeService.user.uid
                          //   },
                          //   {
                          //     'cardNumber': '4000056655665556',
                          //     'expiryDate': '04/24',
                          //     'cardHolderName': 'Jam Dev1',
                          //     'cvvCode': '424',
                          //     'showBackView': false,
                          //     'uid': _stripeService.user.uid
                          //   },
                          //   {
                          //     'cardNumber': '2223003122003222',
                          //     'expiryDate': '04/24',
                          //     'cardHolderName': 'Jam Dev 2',
                          //     'cvvCode': '424',
                          //     'showBackView': false,
                          //     'uid': _stripeService.user.uid
                          //   },
                          // ];
                          // _stripeService
                          //     .saveCreditCard(cards[0])
                          //     .whenComplete(() {
                          //   _stripeService
                          //       .saveCreditCard(cards[1])
                          //       .whenComplete(() {
                          //     _stripeService.saveCreditCard(cards[2]);
                          //   });
                          // });

                          _stripeService.saveCreditCard(
                            {
                              'cardNumber': cardNumber,
                              'expiryDate': expiryDate,
                              'cardHolderName': cardHolderName,
                              'cvvCode': cvvCode,
                              'showBackView': false,
                              'uid': _stripeService.user.uid
                            },
                          ).whenComplete(() {
                            EasyLoading.showSuccess('Card saved Successfully')
                                .then((value) {
                              Navigator.pop(context);
                            });
                          });
                        } else {
                          print('invalide');
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
