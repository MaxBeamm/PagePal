import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cis400_final/globals.dart';
import 'package:cis400_final/SavedPage.dart';
import 'package:cis400_final/LogInSignUpPage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await splashScreenLoadingTasks();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await globalUserInfo.populateFromDatabase(user.uid);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => user == null ? LogInSignUpPage() : const SavedPage(),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      // Do not leave users indefinitely stuck on a loading screen.
      final message = error.toString();
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Unable to start PagePal'),
          content: Text(
            'Firebase initialization failed. Check the Firebase project configuration and network connection.\n\n$message',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _initialize();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: MediaQuery.of(context).size.height / 4),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
