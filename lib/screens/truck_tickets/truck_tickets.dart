import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/truck_tickets_provider.dart';
import 'package:timbertrack_mill_app/screens/truck_tickets/truck_tickets_form.dart';
import 'package:timbertrack_mill_app/enspire_framework/itab_header/itab_header.dart';
import 'package:timbertrack_mill_app/enspire_framework/table_component/table_component.dart';

import 'dart:developer' as devtools;

class TruckTickets extends StatefulWidget {
  const TruckTickets({super.key});

  @override
  State<TruckTickets> createState() => _TruckTicketsState();
}

class _TruckTicketsState extends State<TruckTickets> {
  @override
  void initState() {
    super.initState();
    final handle = context.read<HandleProvider>().handle!;
    context.read<ContractProvider>().fetchContracts(handle);
    context.read<TruckTicketsProvider>().getTruckTickets(handle);
  }

  @override
  Widget build(BuildContext context) {
    final hits = context.watch<TruckTicketsProvider>().truckTickets;

    return Column(
      children: [
        ITabHeader(
          title: 'Truck Tickets',
          buttonTitle: '+ New Truck',
          buttonCallback: () {},
        ),
        Expanded(
          child: TableComponent(
            statusColors: [],
            showSearch: true,
            refresh: true,
            data: hits,
            columns: const [
              {'name': 'ID', 'field': 'id', 'width': 30},
              {'name': 'CONTRACT ID', 'field': 'contractId', 'width': 30},
              {'name': 'CONTENTS', 'field': 'contents', 'width': 40},
            ],
            callback: (data) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TruckTicketsForm(
                    contractId: data?['contractId'],
                  ),
                ),
              );

              devtools.log('Data: $data');
            },
          ),
        )
      ],
    );
  }
}
