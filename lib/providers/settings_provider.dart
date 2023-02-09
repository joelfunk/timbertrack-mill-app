import 'package:flutter/material.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';

import 'dart:developer' as devtools;

class SettingsProvider extends ChangeNotifier {
  final mills = <dynamic>[];
  final landings = <dynamic>[];

  List<Map<String, dynamic>> get locations => [
        {
          'name': 'Mills',
          'locations': <Map<String, dynamic>>[
            for (final mill in mills) {'location': 'mills', ...mill},
          ],
        },
        {
          'name': 'Landings',
          'locations': <Map<String, dynamic>>[
            for (final landing in landings) {'location': 'landings', ...landing},
          ],
        },
      ];

  void fetchSettings(String handle) async {
    await FirebaseEnv.firebaseFirestore
        .collection('$handle/settings/mills')
        .where('deleted', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        mills.add({'id': doc.id, ...data});
      }
    });

    await FirebaseEnv.firebaseFirestore
        .collection('$handle/settings/landings')
        .where('deleted', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();
        landings.add({'id': doc.id, ...data});
      }
    });

    devtools.log('Settings: $mills');
  }
}
