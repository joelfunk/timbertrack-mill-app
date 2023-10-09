import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timbertrack_mill_app/models/user_model.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';

class UsersProvider extends ChangeNotifier {
  List<UserModel> users = [];

  Future<void> subUsers(String handle) async {
    Stream documentStream = FirebaseEnv.firebaseFirestore.collection('$handle/users/users').snapshots();
    documentStream.listen((snapshot) {
      for (final doc in snapshot.docs) {
        var user = UserModel.fromSnapshot(doc);
        users.add(user);
      }

      notifyListeners();
    });
  }
}
