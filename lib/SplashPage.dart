import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cis400_final/globals.dart';
import 'package:cis400_final/SavedPage.dart';
import 'package:cis400_final/LogInSignUpPage.dart';

class SplashPage extends StatefulWidget {
  SplashPage() : super();

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    splashScreenLoadingTasks().then((val) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => globalUserInfo.getSignedIn() ? const SavedPage() : const SavedPage(),//LogInSignUpPage(),
          transitionDuration: const Duration(milliseconds: 500),
          //reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.ease;
            var tween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    });
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', height: MediaQuery.of(context).size.height / 4),
          const Padding(padding: EdgeInsets.only(top: 50)),
          const Center(child:CircularProgressIndicator(color: Colors.green)),
        ],
      ),
    );
  }
}