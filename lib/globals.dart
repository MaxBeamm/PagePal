import 'package:cis400_final/UserInfo.dart';
import 'package:cis400_final/database/Database_core.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

UserInfo globalUserInfo = UserInfo();

enum Pages {
  Saved,
  Browser,
  Profile,
}

var globalCurrentPage = Pages.Saved;

bool platformIsIOS() {
  return Platform.isIOS;
}

// Things that are run before the splash screen is lifted
Future<bool> splashScreenLoadingTasks() async {
  await databaseInit();
  globalUserInfo.init();
  return true;
}

bool isDarkMode(BuildContext context) {
  final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
  bool isDark = brightnessValue == Brightness.dark;
  if (isDark) return true;
  return false;
}