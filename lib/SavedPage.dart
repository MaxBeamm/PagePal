import 'package:cis400_final/globals.dart';
import 'package:cis400_final/widgets/BottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({
    super.key,
  });

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        Text('Saved')
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
