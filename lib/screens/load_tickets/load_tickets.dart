import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/load_tickets_provider.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/screens/load_tickets/forms/truck_tickets_form.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/itab_header/itab_header.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/table_component/table_component.dart';
import 'package:timbertrack_mill_app/screens/load_tickets/log_tags.dart';

import 'dart:developer' as devtools;

class LoadTickets extends StatefulWidget {
  const LoadTickets({required this.contract, required this.customId, super.key});
  final Contract contract;
  final String customId;

  @override
  State<LoadTickets> createState() => _LoadTicketsState();
}

class _LoadTicketsState extends State<LoadTickets> {
  @override
  void initState() {
    super.initState();
    final handle = context.read<HandleProvider>().handle!;

    context.read<SettingsProvider>().fetchSettings(handle);
    context.read<LoadTicketsProvider>().getLoadTickets(handle, widget.contract!);
  }

  @override
  Widget build(BuildContext context) {
    final hits = context.watch<LoadTicketsProvider>().loadTickets;
    final isLoading = context.read<LoadTicketsProvider>().loading;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.customId} ${widget.contract.contractName}')),
      body: Column(
        children: [
          ITabHeader(
            title: 'Load Tickets: ${widget.customId}',
            buttonTitle: '+ Load Ticket',
            buttonCallback: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TruckTicketsForm()));
            },
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!isLoading)
            Expanded(
              child: TableComponent(
                expanded: true,
                statusColors: [],
                showSearch: true,
                refresh: true,
                data: hits,
                columns: const [
                  {'name': 'ID', 'field': 'id', 'width': 25},
                  {'name': 'DATE', 'field': 'date', 'type': 'timestamp', 'width': 35},
                  {'name': 'VOLUME', 'field': 'totalVolume', 'width': 40},
                ],
                callback: (data) {
                  devtools.log('Data: $data');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogTags(
                        contract: widget.contract,
                        customId: widget.customId,
                        logTicket: data!,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
