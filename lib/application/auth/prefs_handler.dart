import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefHandler {
  static Future<bool> isBrowsingAnonymously() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isBrowsingAnonymously") ?? false;
  }

  static Future<void> setIsBrowsingAnonymously(
      bool isBrowsingAnonymously) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isBrowsingAnonymously", isBrowsingAnonymously);
  }

  // TODO: Add when adding onboarding
  // static Future<bool> hasCompletedOnboarding() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool("hasCompletedOnboarding") ?? false;
  // }

  // static Future<void> setHasCompletedOnboarding(
  //     bool hasCompletedOnboarding) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("hasCompletedOnboarding", hasCompletedOnboarding);
  // }

  static Future<void> resetStates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isBrowsingAnonymously");
    // prefs.remove("hasCompletedOnboarding");
  }

  static Future<void> printPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("-----Printing Prefs--------");
    log("Browsing anonymously ${prefs.get("isBrowsingAnonymously")}");
    // log("Has Completed Onboarding ${prefs.get("hasCompletedOnboarding")}");
    log("----------------------------");
  }
}
