// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as devtools;

import 'package:flutter/material.dart' show immutable, ChangeNotifier;

import 'package:timbertrack_mill_app/config/firebase_env.dart';

@immutable
class Contract {
  const Contract({
    required this.contractName,
    required this.type,
    required this.id,
  });

  final String contractName;
  final String type;
  final String id;

  @override
  String toString() => 'Contract(contractName: $contractName, type: $type, id: $id)';
}

class ContractProvider extends ChangeNotifier {
  final contracts = <Contract>[];

  void fetchContracts(String handle) => FirebaseEnv.firebaseFirestore
          .collection('$handle/procurement/contracts')
          .where('deleted', isEqualTo: false)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final contract = Contract(id: doc.id, contractName: data['contractName'] ?? '', type: data['type'] ?? '');
          contracts.add(contract);
        }
        notifyListeners();

        devtools.log('Contracts fetched');
      }).catchError((error) {
        devtools.log('Error fetching contracts', error: error);
      });
}
