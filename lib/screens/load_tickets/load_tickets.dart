import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/load_tickets_provider.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/providers/truck_tickets_provider.dart';
import 'package:timbertrack_mill_app/screens/truck_tickets/forms/truck_tickets_form.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/itab_header/itab_header.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/table_component/table_component.dart';

import 'dart:developer' as devtools;

class LoadTickets extends StatefulWidget {
  const LoadTickets({super.key});

  @override
  State<LoadTickets> createState() => _LoadTicketsState();
}

class _LoadTicketsState extends State<LoadTickets> {
  @override
  void initState() {
    super.initState();
    final handle = context.read<HandleProvider>().handle!;

    context.read<SettingsProvider>().fetchSettings(handle);
    context.read<ContractProvider>().fetchContracts(handle);
    context.read<ContractProvider>().fetchTypes(handle);
    context.read<LoadTicketsProvider>().getLoadTickets(handle);
  }

  @override
  Widget build(BuildContext context) {
    final hits = context.watch<LoadTicketsProvider>().loadTickets;

    return Column(
      children: [
        ITabHeader(
          title: 'Load Tickets',
          buttonTitle: '+ New Ticket',
          buttonCallback: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TruckTicketsForm()));
          },
        ),
        Expanded(
          child: TableComponent(
            expanded: true,
            statusColors: [],
            showSearch: true,
            refresh: true,
            data: hits,
            columns: const [
              {'name': 'ID', 'field': 'id', 'width': 30},
              {'name': 'DATE', 'field': 'date', 'type': 'timestamp', 'width': 30},
              {'name': 'VOLUME', 'field': 'totalVolume', 'width': 40},
            ],
            callback: (data) {
              devtools.log('Data: $data');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TruckTicketsForm(
                    logTicket: data,
                  ),
                ),
              );

              // devtools.log('Data: $data');
            },
          ),
        )
      ],
    );
  }
}
