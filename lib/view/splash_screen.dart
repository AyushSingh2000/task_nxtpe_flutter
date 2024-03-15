import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 90,
            color: Colors.black,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "ShopStop",
            style: GoogleFonts.poppins(
                letterSpacing: .6,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 33),
          ),
          SizedBox(height: 70),
          SpinKitChasingDots(
            color: Colors.blue,
            size: 45,
          )
        ],
      ),
    );
  }
}
