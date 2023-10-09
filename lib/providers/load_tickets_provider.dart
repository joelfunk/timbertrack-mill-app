import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';

class LoadTicketsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> loadTickets = [];

  void getLoadTickets(String handle) async {
    devtools.log('Get Load Tickets');
    final email = FirebaseEnv.firebaseAuth.currentUser!.email!;

    final response = await FirebaseEnv.firebaseFirestore
        .collection('$handle/procurement/logTickets/')
        .where('statusId', isEqualTo: '0')
        .where('contents', isEqualTo: 'logs')
        .get();

    for (final doc in response.docs) {
      final data = doc.data();
      loadTickets.add({...data, 'id': doc.id});
    }

    notifyListeners();
  }
}
