import 'package:flutter/material.dart';

class AppShellController extends ChangeNotifier {
  int tab = 0;

  final GlobalKey<NavigatorState> shopNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> cartNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> ordersNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> adminNavKey = GlobalKey<NavigatorState>();

  List<GlobalKey<NavigatorState>> get keys =>
      [shopNavKey, cartNavKey, ordersNavKey, profileNavKey, adminNavKey];

  void setTab(int i) {
    if (tab == i) return;
    tab = i;
    notifyListeners();
  }

  void goToTabAndPopToRoot(int i) {
    keys[i].currentState?.popUntil((r) => r.isFirst);
    tab = i;
    notifyListeners();
  }
}
