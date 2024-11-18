import 'package:auto_size_text/auto_size_text.dart';
import 'package:cis400_final/SavedPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cis400_final/globals.dart';
import 'package:cis400_final/widgets/PlatformTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogInSignUpPage extends StatefulWidget {
  LogInSignUpPage() : super();

  @override
  _LogInSignUpPageState createState() => _LogInSignUpPageState();
}

class _LogInSignUpPageState extends State<LogInSignUpPage> {
  // Page has two basic states - login (true) or sign up (false)
  bool loginState = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController  = TextEditingController();
  TextEditingController emailController     = TextEditingController();
  TextEditingController passwordController  = TextEditingController();

  bool firstNameRequiredReminder    = false;
  bool lastNameRequiredReminder     = false;
  bool emailRequiredReminder        = false;
  bool passwordRequiredReminder     = false;

  DateTime initialDate = DateTime(2016, 10, 26);
  DateTime? selectedDate;

  bool isLoading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool validateAllFields() {
    bool ret = true;
    if (emailController.text.isEmpty) {
      emailRequiredReminder = true;
      ret = false;
    } else {
      emailRequiredReminder = false;
    }
    if (passwordController.text.isEmpty) {
      passwordRequiredReminder = true;
      ret = false;
    } else {
      passwordRequiredReminder = false;
    }
    if (loginState == false) {
      // Extra fields for sign in state
      if (firstNameController.text.isEmpty) {
        firstNameRequiredReminder = true;
        ret = false;
      } else {
        firstNameRequiredReminder = false;
      }
      if (lastNameController.text.isEmpty) {
        lastNameRequiredReminder = true;
        ret = false;
      } else {
        lastNameRequiredReminder = false;
      }
    }
    setState(() {}); // Update colors
    return ret;
  }

  void _showAlertDialog(BuildContext context, String alert) {
    if (platformIsIOS()) {
      showCupertinoModalPopup <void>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text(alert),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK')
                ),
              ],
            ),
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(alert),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> addUserData(String uuid) async {
    CollectionReference profiles = FirebaseFirestore.instance.collection('profiles');
    bool success = false;
    await profiles.doc(uuid).set({
      'FirstName'       : firstNameController.text,
      'LastName'        : lastNameController.text,
      'Email'           : emailController.text,
    })
        .then((value) {success = true;})
        .catchError((error) {
      print("Failed to add user: $error");
    });
    return success;
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        )
    );
  }

  // These are the fields which only show in the sign up state
  Widget signUpFields(BuildContext context) {
    if (!loginState) {
      return Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child:PlatformTextField(
                      controller: firstNameController,
                      hintText: 'First name',
                      requiredReminder: firstNameRequiredReminder,
                    )),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(child:PlatformTextField(
                      controller: lastNameController,
                      hintText: 'Last name',
                      requiredReminder: lastNameRequiredReminder,
                    ))
                  ],
                )
            ),
          ]
      );
    } else {
      return Container();
    }
  }

  // The login/signup button section depends on login/signup state too
  Widget getLoginSignUpButtons(BuildContext context) {
    if (loginState) {
      return Column(
        children: [
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text('Login'),
                onPressed: () async {
                  if (!validateAllFields()) {
                    print('Required fields not complete!');
                    return;
                  }
                  try {
                    setState(() => isLoading = true);
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    ).then((value) {
                      print('VALUE: ${value.user!.uid}');
                      globalUserInfo.populateFromDatabase(value.user!.uid).then((value) {
                        setState(() => isLoading = false);
                        //Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => const SavedPage(),
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
                    }).onError((error, stackTrace) {
                      setState(() => isLoading = false);
                      _showAlertDialog(context, 'Sign in failed.');
                    });
                  } on FirebaseAuthException catch (e) {
                    setState(() => isLoading = false);
                    if (e.code == 'user-not-found') {
                      _showAlertDialog(context, 'User not found.');
                      print('No user found.');
                    } else if (e.code == 'wrong-password') {
                      _showAlertDialog(context, 'Incorrect password.');
                      print('Wrong password provided for that user.');
                    } else if (e.code == 'user-disabled') {
                      _showAlertDialog(context, 'Account disabled.');
                      print('User account disabled');
                    } else if (e.code == 'invalid-email') {
                      _showAlertDialog(context, 'Email not found.');
                      print('Invalid user email');
                    }
                  }
                },
              )
          ),
          const Padding(padding: EdgeInsets.only(top: 10),),
          TextButton(
            onPressed: () {
              setState(() {
                loginState = false;
              });
            },
            child: const Text('Need an account? Sign Up', style: TextStyle(color: Colors.green),),
          ),
          TextButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                emailRequiredReminder = true;
                setState(() {}); // Update colors
                return;
              }
              try {
                setState(() => isLoading = true);
                final credential = await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((value) {
                  setState(() => isLoading = false);
                  _showAlertDialog(context, 'Check your email for password reset.');
                });
              } on FirebaseAuthException catch (e) {
                setState(() => isLoading = false);
                // TODO: Show error message to user
                if (e.code == 'user-not-found') {
                  _showAlertDialog(context, 'User not found.');
                  print('No user found.');
                } else if (e.code == 'wrong-password') {
                  _showAlertDialog(context, 'Incorrect password.');
                  print('Wrong password provided for that user.');
                } else if (e.code == 'user-disabled') {
                  _showAlertDialog(context, 'Account disabled.');
                  print('User account disabled');
                } else if (e.code == 'invalid-email') {
                  _showAlertDialog(context, 'Email not found.');
                  print('Invalid user email');
                }
              }
            },
            child: const Text('Forgot Password', style: TextStyle(color: Colors.green),),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text('Sign Up'),
                onPressed: () async {
                  if (!validateAllFields()) {
                    print('Required fields not complete!');
                    return;
                  }
                  try {
                    setState(() => isLoading = true);
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    ).then((value) {
                      // User account successfully made
                      // Fill up their respective database document
                      if (value.user == null) {
                        setState(() => isLoading = false);
                        throw Exception('account-made-null');
                      }
                      addUserData(value.user!.uid).then((success) {
                        if (success) {
                          setState(() => isLoading = false);
                          //Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => const SavedPage(),
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
                        } else {
                          setState(() => isLoading = false);
                          throw Exception('account-made-null');
                        }
                      });
                    });
                  } on FirebaseAuthException catch (e) {
                    // TODO: Show error message to user
                    setState(() => isLoading = false);
                    if (e.code == 'weak-password') {
                      _showAlertDialog(context, 'Password too weak.');
                      print('The password ${passwordController.text} provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      _showAlertDialog(context, 'Email in use for another account');
                      print('The account already exists for that email.');
                    } else if (e.code == 'account-made-null') {
                      _showAlertDialog(context, 'Error failed to make account.');
                      print('Generated account was null!');
                    }
                  } catch (e) {
                    print(e);
                    setState(() => isLoading = false);
                  }
                },
              )
          ),
          TextButton(
            onPressed: () {
              setState(() {
                loginState = true;
              });
            },
            child: const Text('Already have an account? Login', style: TextStyle(color: Colors.green),),
          ),
        ],
      );
    }
  }

  Widget getBody(BuildContext context) {
    return ListView(
      children: <Widget> [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 50),
          child: Image.asset('assets/logo.png', height: MediaQuery.of(context).size.height / 4),
        ),
        signUpFields(context),
        Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: PlatformTextField(
              controller: emailController,
              hintText: 'Email address',
              requiredReminder: emailRequiredReminder,
            )
        ),
        Container(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: PlatformTextField(
              controller: passwordController,
              hintText: 'Password',
              requiredReminder: passwordRequiredReminder,
              obscureText: true,
            )
        ),
        const Padding(padding: EdgeInsets.only(top: 20),),
        getLoginSignUpButtons(context),
        isLoading ? const CircularProgressIndicator(color: Colors.green) : Container(),
        SizedBox(height: MediaQuery.of(context).size.height / 2),
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
              //Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const SavedPage(),
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
            },
          ),
          middle: const Text('Log in / Sign up', style: TextStyle(color: Colors.black87)),
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
          title: const Text('Log in / Sign up', style: TextStyle(color: Colors.black87)),
        ),
        body: getBody(context),
      );
    }
  }
}