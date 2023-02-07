import 'package:flutter/material.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';

class SettingsProvider extends ChangeNotifier {
  final mills = <dynamic>[];
  final landings = <dynamic>[];

  void fetchSettings(String handle) async {
    await FirebaseEnv.firebaseFirestore.collection('$handle/settings/mills').get().then((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        mills.add({'id': doc.id, ...data});
      }
    });

    await FirebaseEnv.firebaseFirestore.collection('$handle/settings/landings').get().then((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        landings.add({'id': doc.id, ...data});
      }
    });
  }
}
