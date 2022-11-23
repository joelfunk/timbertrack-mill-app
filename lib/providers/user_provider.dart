import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:timbertrack_mill_app/models/user_model.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';

class UserProvider extends ChangeNotifier {
  final _roles = <String>[];

  final companyInfo = <String, dynamic>{};

  String? handle;
  UserModel? _user;
  String _userEmail = '';
  bool _isLoading = false;

  UserModel? get getUserInfo => _user;
  get getUserEmail => _userEmail;
  get isLoading => _isLoading;

  List<String> get roles => _roles;

  Future<void> clear() async {
    _roles.clear();
    companyInfo.clear();
    handle = null;
    _userEmail = '';
    _isLoading = false;
  }

  void setRoles(List userRoles) {
    for (final role in userRoles) {
      _roles.add(role);
    }
    notifyListeners();
  }

  Future<void> subUser(String email, String handle) async {
    _userEmail = email;
    Stream documentStream = FirebaseEnv.firebaseFirestore.collection('$handle/users/users').doc(email).snapshots();
    documentStream.listen((snapshot) {
      _user = UserModel.fromSnapshot(snapshot);
      notifyListeners();
    });
  }

  Future updateUserProfile(UserModel user, String handle) async {
    DocumentReference userDoc = FirebaseEnv.firebaseFirestore.collection('$handle/users/users/').doc(_userEmail);
    _isLoading = true;
    notifyListeners();

    return userDoc.update({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'photoUrl': user.photoUrl,
    }).then((value) {
      _isLoading = false;
      notifyListeners();
    });
  }
}
