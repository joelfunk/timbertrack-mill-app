import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/load_tickets_provider.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/screens/load_tickets/forms/truck_tickets_form.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/itab_header/itab_header.dart';
import 'package:timbertrack_mill_app/enspire_framework-port/table_component/table_component.dart';

import 'dart:developer' as devtools;

class LogTags extends StatefulWidget {
  const LogTags({required this.contract, required this.logTicket, required this.customId, super.key});
  final Contract contract;
  final String customId;
  final Map<String, dynamic> logTicket;

  @override
  State<LogTags> createState() => _LogTagsState();
}

class _LogTagsState extends State<LogTags> {
  List<Map<String, dynamic>> tags = [];

  @override
  void initState() {
    super.initState();
    final handle = context.read<HandleProvider>().handle!;
    for (Map<String, dynamic> tag in widget.logTicket['logTags']) {
      tags.add(tag);
    }

    context.read<SettingsProvider>().fetchSettings(handle);
    context.read<LoadTicketsProvider>().getLoadTickets(handle, widget.contract);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('#${widget.logTicket['id']} Log Tags')),
      body: Column(
        children: [
          ITabHeader(
            title: 'Volume: ${widget.logTicket['totalVolume']}',
            buttonTitle: '+ Log Tag',
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
              data: tags,
              columns: const [
                {'name': '#', 'field': 'logNumber', 'width': 10},
                {'name': 'Species', 'field': 'species', 'width': 25},
                {'name': 'Gr', 'field': 'grade', 'width': 15},
                {'name': 'Diam', 'field': 'diameter', 'width': 20},
                {'name': 'Len', 'field': 'length', 'width': 15},
                {'name': 'Vol', 'field': 'volume', 'width': 15},
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
              },
            ),
          )
        ],
      ),
    );
  }
}
