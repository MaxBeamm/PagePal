import 'package:cis400_final/globals.dart';
import 'package:cis400_final/widgets/BottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({
    super.key,
  });

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        Text('Browser')
      ],
    );

    if (platformIsIOS()) {
      // IOS
      return CupertinoTabScaffold(
        tabBar: BottomBar(buildContext: context).bottomBarIOS(),
        tabBuilder: (BuildContext context, int index) {
          return body;
        },
      );
    } else {
      // Android
      return Scaffold(
        backgroundColor: isDarkMode(context) ? Colors.black : null,
        bottomNavigationBar: BottomAppBar(
          child: BottomBar(buildContext: context),
        ),
        body: body,
      );
    }
  }
}
