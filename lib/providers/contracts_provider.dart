import 'package:flutter/material.dart' show immutable, ChangeNotifier;
import 'package:timbertrack_mill_app/config/firebase_env.dart';

import 'dart:developer' as devtools;

@immutable
class Contract {
  const Contract({
    required this.contractName,
    required this.type,
  });

  final String contractName;
  final String type;
}

class ContractProvider extends ChangeNotifier {
  final contracts = <Contract>[];

  Future<void> fetchContracts(String handle) => FirebaseEnv.firebaseFirestore
          .collection('$handle/procurement/contracts')
          .where('deleted', isEqualTo: false)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final contract = Contract(contractName: data['contractName'] ?? '', type: data['type'] ?? '');
          contracts.add(contract);
        }
      }).catchError((error) {
        devtools.log('Error fetching contracts', error: error);
      });
}
