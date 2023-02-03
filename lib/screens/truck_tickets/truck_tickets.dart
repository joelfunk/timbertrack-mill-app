import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timbertrack_mill_app/enspire_framework/itab_header/itab_header.dart';
import 'package:timbertrack_mill_app/enspire_framework/table_component/table_component.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/providers/truck_tickets_provider.dart';
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
    devtools.log('Handle: $handle');
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
              {'name': 'ID', 'field': 'id', 'width': 65},
              {'name': 'CONTENTS', 'field': 'contents', 'width': 35},
            ],
            callback: (data) {
              devtools.log('Data: $data');
            },
          ),
        )
      ],
    );
  }
}
