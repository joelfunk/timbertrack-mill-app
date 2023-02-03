import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/contracts_provider.dart';

import 'dart:developer' as devtools;

class TruckTicketsForm extends StatefulWidget {
  const TruckTicketsForm({required this.contractId, super.key});
  final String? contractId;

  @override
  State<TruckTicketsForm> createState() => _TruckTicketsFormState();
}

class _TruckTicketsFormState extends State<TruckTicketsForm> {
  Contract? contract;

  @override
  void initState() {
    super.initState();
    // Fetch contract for this truck ticket
    if (widget.contractId != null) {
      final contract =
          context.read<ContractProvider>().contracts.singleWhere((contract) => contract.id == widget.contractId);
      devtools.log('Contract: $contract');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Based on the contract add additional fields
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Tickets Form'),
        centerTitle: true,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
