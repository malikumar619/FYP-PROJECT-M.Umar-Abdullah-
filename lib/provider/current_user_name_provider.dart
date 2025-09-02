import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUserNameProvider extends ChangeNotifier {
  String _name = "Not logged in";

  String get name => _name;

  Future<void> fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('registeredUsers')
            .where('userEmail', isEqualTo: user.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _name = snapshot.docs.first['userName'];
          notifyListeners(); // Notify UI to update
        }
      }
    } catch (e) {
      log("Error fetching user name: $e");
    }
  }
}
