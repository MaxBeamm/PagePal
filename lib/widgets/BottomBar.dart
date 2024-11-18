import 'package:cis400_final/BrowserPage.dart';
import 'package:cis400_final/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cis400_final/globals.dart';
import 'package:cis400_final/SavedPage.dart';

class BottomBar extends StatelessWidget {
  BottomBar({
    super.key,
    required this.buildContext,
  });

  final int _startingIndex = globalCurrentPage.index;
  BuildContext buildContext;

  void _onItemTapped(int index, BuildContext context) {
    globalCurrentPage = Pages.values[index];
    switch (globalCurrentPage) {
      case Pages.Saved: {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const SavedPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      }
      case Pages.Browser: {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const BrowserPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      }
      case Pages.Profile: {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const ProfilePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      }
    }
  }

  // IOS
  CupertinoTabBar bottomBarIOS() {
    return CupertinoTabBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.computer_outlined), label: 'Browser'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
      ],
      // type: BottomNavigationBarType.fixed,
      // from https://github.com/flutter/flutter/issues/13642
      currentIndex: _startingIndex,
      activeColor: Colors.lightGreen[800],
      //amber[800],
      onTap: (int index){return _onItemTapped(index, buildContext);},
    );
  }

  // ANDROID
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: isDarkMode(context) ? Colors.black/*87*/ : null,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.save), label: 'Saved'),
        BottomNavigationBarItem(icon: Icon(Icons.computer_outlined), label: 'Browser'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
      ],
      type: BottomNavigationBarType.fixed,
      // from https://github.com/flutter/flutter/issues/13642
      currentIndex: _startingIndex,
      selectedItemColor: Colors.lightGreen[800],
      unselectedItemColor: isDarkMode(context) ? Colors.grey.shade400 : null,
      //amber[800],
      onTap: (int index){return _onItemTapped(index, context);},
    );
  }
}