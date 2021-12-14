import 'package:flutter/material.dart';
import 'package:grocery/providers/location_provider.dart';
import 'package:grocery/screens/map_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery addreaa not set',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please update your delivery location to find nearest stores for you ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            CircularProgressIndicator(),
            Container(
              width: 600,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _loading
                ? CircularProgressIndicator()
                // ignore: deprecated_member_use
                : FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.selectedAddress != null) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          print('Permission not allowed');
                          setState(() {
                            _loading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please allow permission to find nearest stores for you')));
                        });
                        print('Permission not allowed');
                      }
                    },
                    child: Text(
                      'Set Your Location',
                      style: TextStyle(color: Colors.white),
                    )),
          ],
        ),
      ),
    );
  }
}
