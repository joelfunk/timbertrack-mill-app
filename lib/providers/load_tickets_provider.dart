import 'dart:developer' as devtools;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';

class LoadTicketsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> loadTickets = [];

  void getLoadTickets(String handle, Contract contract) async {
    devtools.log('Get Load Tickets');

    final response = await FirebaseEnv.firebaseFirestore
        .collection('$handle/procurement/logTickets/')
        .where('statusId', isEqualTo: '0')
        .where('contents', isEqualTo: 'logs')
        .where('contractId', isEqualTo: contract.id)
        .get();

    for (final doc in response.docs) {
      final data = doc.data();
      var formatter = NumberFormat('###,###,###');
      loadTickets.add({...data, 'totalVolume': '${formatter.format(data['totalVolume'] * 10)} bf', 'id': doc.id});
    }
    loadTickets.sort((a, b) => b['date'].compareTo(a['date']));

    notifyListeners();
  }
}
