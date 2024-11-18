import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cis400_final/globals.dart';
import 'package:cis400_final/widgets/PlatformTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage() : super();

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController passwordController  = TextEditingController();
  TextEditingController newPasswordController  = TextEditingController();

  bool passwordRequiredReminder = false;
  bool newPasswordRequiredReminder = false;

  bool showWrongPassword = false;
  bool showInvalidNewPassword = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<bool> validateCurrentPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: globalUserInfo.email,
          password: passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      /*if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }*/
      return false;
    }
    return true;
  }

  Future<bool> validateAllFields() async {

    newPasswordRequiredReminder = false;
    showWrongPassword = false;
    passwordRequiredReminder = false;
    showInvalidNewPassword = false;

    bool ret = true;
    if (newPasswordController.text.isEmpty) {
      newPasswordRequiredReminder = true;
      ret = false;
    }
    if (!(await validateCurrentPassword())) {
      showWrongPassword = true;
      ret = false;
    }
    if (passwordController.text.isEmpty) {
      passwordRequiredReminder = true;
      ret = false;
    }
    // TODO: Verify current password
    setState(() {}); // Update colors
    return ret;
  }

  Widget getBody(BuildContext context) {
    return Column(
      children: <Widget> [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
          child: Image.asset('assets/logo.png', height: MediaQuery.of(context).size.height / 4),
        ),
        Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showWrongPassword ? const Align(alignment: Alignment.topLeft, child:AutoSizeText('Incorrect password', style: TextStyle(fontSize: 16, color: Colors.red))) : Container(),
                showWrongPassword ? const Padding(padding: EdgeInsets.only(top: 5)) : Container(),
                PlatformTextField(
                  controller: passwordController,
                  hintText: 'Current password',
                  requiredReminder: passwordRequiredReminder,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                showInvalidNewPassword ? const Align(alignment: Alignment.topLeft, child:AutoSizeText('Invalid new password', style: TextStyle(fontSize: 16, color: Colors.red))) : Container(),
                showInvalidNewPassword ? const Padding(padding: EdgeInsets.only(top: 5)) : Container(),
                PlatformTextField(
                  controller: newPasswordController,
                  hintText: 'New password',
                  requiredReminder: newPasswordRequiredReminder,
                )
              ],
            )
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          child: const Text('Change Password', style: TextStyle(fontSize: 18)),
          onPressed: () async {
            if (!(await validateAllFields())) {
              print('Required fields not complete!');
              return;
            }
            final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
            User? currentUser = firebaseAuth.currentUser;
            if (currentUser != null) {
              currentUser.updatePassword(newPasswordController.text).then((value) {
                Navigator.pop(context);
              }).catchError((err) {
                setState((){showInvalidNewPassword = true;});
              });
            }
          },
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (platformIsIOS()) {
      // IOS
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.green,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_sharp, color: Colors.black),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          middle: const Text('Change Password', style: TextStyle(color: Colors.black87)),
        ),
        child: getBody(context),
      );
    } else {
      // Android
      return Scaffold(
        backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
          backgroundColor: Colors.green,
          title: const Text('Change Password', style: TextStyle(color: Colors.black87)),
        ),
        body: getBody(context),
      );
    }
  }
}