import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:digi_cafe_admin/Views/splash_screen.dart';
import 'package:digi_cafe_admin/style/colors.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

void enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  ConnectivityUtils.instance.setServerToPing('https://www.google.com/');

  // SharedPreferences.setMockInitialValues({});
  enablePlatformOverrideForDesktop();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(focusColor: colors.buttonColor),
      home: new Splash_Screen(),
    );
  }
}
