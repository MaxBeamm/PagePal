import 'package:auto_size_text/auto_size_text.dart';
import 'package:cis400_final/ChangePasswordPage.dart';
import 'package:cis400_final/LogInSignUpPage.dart';
import 'package:cis400_final/globals.dart';
import 'package:cis400_final/widgets/BottomBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /* Widget _deletePopupDialog(BuildContext context) {
    List<Widget> actionsShared = [
      TextButton(
        onPressed: () async {
          User? curUsr = FirebaseAuth.instance.currentUser;
          String userUuid = globalUserInfo.uuid;
          FirebaseFirestore.instance.collection("profiles").doc(userUuid).delete().then((res) async {
            if (curUsr != null) {
              curUsr!.delete().then((value) async {
                while (globalUserInfo.getSignedIn()) {
                  await Future.delayed(const Duration(milliseconds: 200));
                }
                setState(() {});
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => LogInSignUpPage(),
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
            }
          });
        },
        child: Text('Confirm', style: platformIsIOS() ? TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black) : null),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel', style: platformIsIOS() ? TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black) : null),
      )
    ];
    if (platformIsIOS()) {
      return CupertinoAlertDialog(
        title: const Text('Confirm Delete Account', style: TextStyle(color: Colors.red)),
        content: Text('You will loose ALL data associated with this account, including orders and deal progress.', style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black)),
        actions: actionsShared,
      );
    } else {
      return AlertDialog(
        title: const Text('Confirm Delete Account', style: TextStyle(color: Colors.red)),
        content: const Text('You will loose ALL data associated with this account, including orders and deal progress.'),
        actions: actionsShared,
      );
    }
  } */

  Widget signInfoFields(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText('First Name: ${globalUserInfo.firstName}', minFontSize: 18, style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black)),
          const Padding(padding: EdgeInsets.only(top: 10)),
          AutoSizeText('Last Name: ${globalUserInfo.lastName}', minFontSize: 18, style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black)),
          const Padding(padding: EdgeInsets.only(top: 10)),
          AutoSizeText('Email: ${globalUserInfo.email}', minFontSize: 18, style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black)),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 32,
          right: MediaQuery.of(context).size.width / 32,
          top: MediaQuery.of(context).size.width / 32,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: globalUserInfo.getSignedIn() ? [
              Card(
                  color: isDarkMode(context) ? Colors.grey.shade800 : null,
                  elevation: 2,
                  child: Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width), // Just makes the card expand to the width
                          Text('Profile Info', style: TextStyle(fontSize: 32, color: isDarkMode(context) ? Colors.white : Colors.black, fontStyle: FontStyle.normal, decoration: TextDecoration.none)),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          signInfoFields(context),
                        ],
                      )
                  )
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Divider(),
              const Padding(padding: EdgeInsets.only(top: 5)),
              GestureDetector(
                child: Text('Change Password', style: TextStyle(fontSize: 23, color: (isDarkMode(context) ? Colors.white : Colors.black), fontStyle: FontStyle.normal, decoration: TextDecoration.none)),
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => ChangePasswordPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        // Slide up / down transition
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              const Divider(),
              const Padding(padding: EdgeInsets.only(top: 5)),
              /*GestureDetector(
                child: Text('Delete Account', style: TextStyle(fontSize: 23, color:  (isDarkMode(context) ? Colors.white : Colors.black), fontStyle: FontStyle.normal, decoration: TextDecoration.none)),
                onTap: () {
                  if (platformIsIOS()) {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => _deletePopupDialog(context),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _deletePopupDialog(context),
                    );
                  }
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),*/
              const Divider(),
              const Padding(padding: EdgeInsets.only(top: 5)),
              GestureDetector(
                child: Text('Sign Out', style: TextStyle(fontSize: 23, color: (isDarkMode(context) ? Colors.white : Colors.black), fontStyle: FontStyle.normal, decoration: TextDecoration.none)),
                onTap: () {FirebaseAuth.instance.signOut().then((value) {
                  setState(() {}); // Updates "Sign Out" to "Sign In', in case they pop the sign in page
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => LogInSignUpPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        // Slide up / down transition
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });},
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              const Divider(),
            ] : [
              GestureDetector(
                child: Text('Sign In', style: TextStyle(fontSize: 23, color: (isDarkMode(context) ? Colors.white : Colors.black), fontStyle: FontStyle.normal, decoration: TextDecoration.none),),
                onTap: () {
                  // Just pushing this to the navigator stack, so they can back out
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => LogInSignUpPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        // Slide up / down transition
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ]
        )
    );

    if (platformIsIOS()) {
      // IOS
      return CupertinoTabScaffold(
        tabBar: BottomBar(buildContext: context).bottomBarIOS(),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.green,
              middle: Text(
                '${globalUserInfo.firstName} ${globalUserInfo.lastName}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            child: body,
          );
        },
      );
    } else {
      // Android
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text(
            '${globalUserInfo.firstName} ${globalUserInfo.lastName}',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: isDarkMode(context) ? Colors.black : null,
        bottomNavigationBar: BottomAppBar(
          child: BottomBar(buildContext: context),
        ),
        body: body,
      );
    }
  }
}
