import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:digi_cafe_admin/style/fonts_style.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:digi_cafe_admin/Views/Login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'MyWidgets.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              padding: EdgeInsets.only(left: 25),
              child: Image.asset('images/logo.png'),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: MyWidgets.getTextWidget(
                    text: 'Digi Café', size: Fonts.heading1_size)),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MyWidgets.getTextWidget(text: 'Admin')),
            Container(
              width: 200,
              padding: EdgeInsets.only(top: 50),
              child: SpinKitThreeBounce(color: colors.buttonColor),
            ),
          ],
        ),
      ),
    );
  }
}
