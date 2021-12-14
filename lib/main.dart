import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery/providers/auth_provider.dart';
import 'package:grocery/providers/cart_provider.dart';
import 'package:grocery/providers/coupon_provider.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/providers/order_provider.dart';
import 'package:grocery/providers/store_provider.dart';
import 'package:grocery/screens/HomeScreen.dart';
import 'package:grocery/screens/cart_screen.dart';
import 'package:grocery/screens/landing_screen.dart';
import 'package:grocery/screens/login_screen.dart';
import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/screens/map_screen.dart';
import 'package:grocery/screens/my_orders_screen.dart';
import 'package:grocery/screens/payment/razorpay/razorpay_payment_screen.dart';
import 'package:grocery/screens/payment/stripe/existing-cards.dart';
import 'package:grocery/screens/payment/payment_home.dart';
import 'package:grocery/screens/product_details_screen.dart';
import 'package:grocery/screens/product_list_screen.dart';
import 'package:grocery/screens/profile_screen.dart';
import 'package:grocery/screens/profile_update_screen.dart';
import 'package:grocery/screens/vendor_home_screen.dart';
import 'package:grocery/screens/welcome_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:grocery/services/payment/create_new_card_screen.dart';
import 'package:grocery/services/payment/credit_card_list.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import 'screens/spash_screen.dart';

// flutter run --no-sound-null-safety
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF84c225), fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductListScreen.id: (context) => ProductListScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
        CartScreen.id: (context) => CartScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        UpdateProfile.id: (context) => UpdateProfile(),
        ExistingCardsPage.id: (context) => ExistingCardsPage(),
        PaymentHome.id: (context) => PaymentHome(),
        MyOrders.id: (context) => MyOrders(),
        CreditCardList.id: (context) => CreditCardList(),
        CreateNewCreditCard.id: (context) => CreateNewCreditCard(),
        RazorPaymentScreen.id: (context) => RazorPaymentScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
