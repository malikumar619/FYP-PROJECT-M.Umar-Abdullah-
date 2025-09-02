import 'package:flutter/material.dart';

class BottomNavigationBarIndexProvider extends ChangeNotifier{
  late int index;
  BottomNavigationBarIndexProvider({
    this.index = 0,
  });

  void changeIndex({
    required int newIndex,
  }) async {
    index = newIndex;
    notifyListeners();
  }
}