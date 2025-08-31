import 'package:flutter/material.dart';

class YourTabController with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  int _currentTab = 0;

  Locale get currentLocale => _currentLocale;
  int get currentTab => _currentTab;

  void changeTab(int index) {
    _currentTab = index;
    _currentLocale = index == 0 ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }
}