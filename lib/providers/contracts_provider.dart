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
    required this.availableLogging,
  });

  final String contractName;
  final String type;
  final String id;
  final List<dynamic> availableLogging;

  @override
  String toString() =>
      'Contract(contractName: $contractName, type: $type, id: $id, availableLogging: $availableLogging)';
}

class ContractProvider extends ChangeNotifier {
  final contracts = <Contract>[];
  List<dynamic> contractTypes = <dynamic>[];

  void fetchContracts(String handle) => FirebaseEnv.firebaseFirestore
          .collection('$handle/procurement/contracts')
          .where('deleted', isEqualTo: false)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          final data = doc.data();

          final contract = Contract(
            id: doc.id,
            contractName: data['contractName'] ?? '',
            type: data['type'] ?? '',
            availableLogging: data['availableLogging'] ?? [],
          );

          contracts.add(contract);
        }
        notifyListeners();

        devtools.log('Contracts fetched');
      }).catchError((error) {
        devtools.log('Error fetching contracts', error: error);
      });

  void fetchTypes(String handle) =>
      FirebaseEnv.firebaseFirestore.collection(handle).doc('procurement').get().then((doc) {
        final data = doc.data()!;
        final types = data['types'] as List<dynamic>;

        for (final type in types) {
          contractTypes.add(type);
        }
      }).onError((error, stackTrace) {
        devtools.log('Error fetching types', error: error);
        devtools.log('Stack Trace: ', error: stackTrace);
      });
}
