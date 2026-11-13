import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cis400_final/SplashPage.dart';
import 'package:cis400_final/globals.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //precacheImages(context);
    if (platformIsIOS()) {
      // IOS entry point
      return CupertinoApp(
        title: 'PagePal',
        theme: const CupertinoThemeData(
          //colorScheme:
          primaryColor: Colors.green,
          primaryContrastingColor: Colors.black,
        ),
        home: SplashPage(),
      );
    } else {
      // Android entry point
      return MaterialApp(
        title: 'PagePal',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SplashPage(),
      );
    }
  }
}