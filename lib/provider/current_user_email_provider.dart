import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUserEmailProvider extends ChangeNotifier {
  String _email = "Not logged in";

  String get email => _email;

  Future<void> fetchUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('registeredUsers')
            .where('userEmail', isEqualTo: user.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          _email = snapshot.docs.first['userEmail'];
          notifyListeners(); // Notify UI to update
        }
      }
    } catch (e) {
      log("Error fetching user name: $e");
    }
  }
}
