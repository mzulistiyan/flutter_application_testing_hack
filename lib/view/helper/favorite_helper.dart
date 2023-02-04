import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteHelper {
  void saveToken(int idStory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('fav', idStory);
    debugPrint('saveID : ${prefs.getInt('fav').toString()}');
  }

  Future<int> getIdStory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idStory = prefs.getInt('fav');
    if (idStory != null) {
      return idStory;
    } else {
      return 0;
    }
  }
}
