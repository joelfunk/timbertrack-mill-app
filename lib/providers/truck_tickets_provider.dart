import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';

class TruckTicketsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> truckTickets = [];

  void getTruckTickets(String handle) async {
    devtools.log('Get Truck Tickets');
    final email = FirebaseEnv.firebaseAuth.currentUser!.email!;

    final response = await FirebaseEnv.firebaseFirestore
        .collection('$handle/procurement/logTickets/')
        .where('status', isEqualTo: 'open')
        .where('scaler', isEqualTo: email)
        .get();

    for (final doc in response.docs) {
      final data = doc.data();
      truckTickets.add({...data, 'id': doc.id});
    }
  }
}
