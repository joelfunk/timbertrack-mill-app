import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/providers/users_provider.dart';
import 'package:timbertrack_mill_app/screens/load_tickets/load_tickets.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/table_component/table_component.dart';
import 'package:timbertrack_mill_app/constants/constants.dart';

import 'dart:developer' as devtools;

class Contracts extends StatefulWidget {
  const Contracts({super.key});

  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
  @override
  void initState() {
    super.initState();
    final handle = context.read<HandleProvider>().handle!;

    context.read<SettingsProvider>().fetchSettings(handle);
    context.read<ContractProvider>().fetchContracts(handle);
    context.read<ContractProvider>().fetchTypes(handle);
  }

  @override
  Widget build(BuildContext context) {
    final contractsTable = context.watch<ContractProvider>().contractsTable;
    final contracts = context.watch<ContractProvider>().contracts;
    final users = context.read<UsersProvider>().users;

    List<Map<String, dynamic>> data = [];
    for (var contract in contractsTable) {
      var user = users.firstWhereOrNull((u) => u.id == contract['foresterId']);
      contract['customId'] = (user?.firstName[0] ?? '') + (user?.lastName[0] ?? '') + '-' + contract['id'];
      data.add(contract);
    }

    return Column(
      children: [
        Expanded(
          child: TableComponent(
            expanded: true,
            statusColors: [],
            showSearch: true,
            refresh: true,
            data: data,
            groupBy: const {'field': 'position', 'options': kContractTypes},
            columns: const [
              {'name': 'Name', 'field': 'contractName', 'width': 70},
              {'name': 'ID', 'field': 'customId', 'width': 30},
            ],
            callback: (data) {
              devtools.log('Data: $data');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  var contract = contracts.firstWhereOrNull((c) => c.id == data?['id']);
                  return LoadTickets(contract: contract);
                }),
              );
            },
          ),
        )
      ],
    );
  }
}
