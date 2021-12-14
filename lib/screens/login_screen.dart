import 'package:flutter/material.dart';
import 'package:grocery/providers/auth_provider.dart';
import 'package:grocery/providers/location_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: auth.error == "invalid OTP" ? true : false,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          auth.error,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Enter your phone number to proceed",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    prefixText: "+254",
                    labelText: "10 digit mobile number",
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumberController,
                  onChanged: (value) {
                    if (value.length == 10) {
                      setState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      setState(() {
                        _validPhoneNumber = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false : true,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              auth.loading = true;
                              auth.screen = 'MapScreen';
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.address =
                                  locationData.selectedAddress.addressLine;
                            });
                            String number =
                                '+254${_phoneNumberController.text}';
                            auth
                                .verifyPhone(
                              context: context,
                              number: number,
                              // latitude: locationData.latitude,
                              // longitude: locationData.longitude,
                              // address: locationData.selectedAddress.addressLine,
                            )
                                .then((value) {
                              _phoneNumberController.clear();
                              setState(() {
                                auth.loading = false;
                              });
                            });
                          },
                          color: _validPhoneNumber
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          child: auth.loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  _validPhoneNumber
                                      ? "CONTINUE"
                                      : "ENTER PHONE NUMBER",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
