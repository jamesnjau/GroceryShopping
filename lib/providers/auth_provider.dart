import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/screens/landing_screen.dart';
import 'package:grocery/screens/main_screen.dart';
import 'package:grocery/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = "";
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  late String screen;
  late double latitude;
  late double longitude;
  late String address;
  late String location;
  DocumentSnapshot? snapshot;

  Future<void> verifyPhone({
    required BuildContext context,
    required String number,
  }) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOptSend = (String verId, int resendToken) {
      this.verificationId = verId;

      //open dialog to enter received OTP SMS
      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOptSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text("Verification Code"),
                SizedBox(
                  height: 6,
                ),
                Text("Enter 6 digit OTP received as SMS",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    AuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsOtp);

                    final User user =
                        (await _auth.signInWithCredential(phoneAuthCredential))
                            .user;

                    if (user != null) {
                      this.loading = false;
                      notifyListeners();

                      _userServices.getUserById(user.uid).then((snapshot) {
                        if (snapshot.exists) {
                          //user data aleady exist
                          if (this.screen == 'Login') {
                            //need to check user data already exist in db or not
                            //if its 'login'. no new data , so no need to update
                            if (snapshot.data()['address'] != null) {
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.id);
                            }
                            Navigator.pushReplacementNamed(
                                context, LandingScreen.id);
                          } else {
                            //need to update new selected address
                            updateUser(id: user.uid, number: user.phoneNumber);
                            Navigator.pushReplacementNamed(
                                context, MainScreen.id);
                          }
                        } else {
                          //user data does not exists, will create new data in db
                          _createUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(
                              context, LandingScreen.id);
                        }
                      });
                    } else {
                      print('Login failed');
                    }
                  } catch (e) {
                    this.error = "invalid OTP";
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "DONE",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({required String id, required String number}) {
    _userServices.createUserData({
      "id": id,
      "number": number,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "address": this.address,
      "location": this.location
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({required String id, required String number}) async {
    try {
      _userServices.updateUserData({
        "id": id,
        "number": number,
        "latitude": this.latitude,
        "longitude": this.longitude,
        "address": this.address,
        "location": this.location
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .get();
    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      this.snapshot = null;
      notifyListeners();
    }
    return result;
  }
}
