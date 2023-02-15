import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:timbertrack_mill_app/extensions/capitalize_first.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';

import 'dart:developer' as devtools;

// Form Fields:

//'contractId': null,
// 'contents': null,
// 'logginId': null,
// location: null,

class Type1 extends StatelessWidget {
  const Type1({
    required this.loggingId,
    required this.location,
    required this.contract,
    required this.formStateCallback,
    super.key,
  });

  final Contract? contract;
  final String? loggingId;
  final String? location;

  final Function(String, String) formStateCallback;

  List<DropdownMenuItem<Map<String, dynamic>>> getMenuItems(Map<String, List<Map<String, dynamic>>> items) {
    final widgets = <DropdownMenuItem<Map<String, dynamic>>>[];

    for (final item in items.entries) {
      final key = item.key;
      final listOfLocations = item.value;

      widgets.add(
        DropdownMenuItem(
          enabled: false,
          child: Text(
            key.firstLetter(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      for (final location in listOfLocations) {
        widgets.add(
          DropdownMenuItem(
            value: location,
            child: Text(
              location['name'],
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  // If cannot find, default to mills|3000
  Map<String, dynamic>? getSelectedLocation(String? location, Map<String, List<Map<String, dynamic>>> locations) {
    if (location == null) return null;

    final locationName = location.split('|')[0];
    final locationId = location.split('|')[1];

    final listOfLocations = locations[location] ?? [];

    for (final e in listOfLocations) {
      if (e['id'] == locationId && e['location'] == locationName) {
        return e;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final locations = context.read<SettingsProvider>().locations;
    final availableLogging =
        contract?.availableLogging.map((e) => e).cast<Map<String, dynamic>>().toList() ?? <Map<String, dynamic>>[];
    final selectedLoggingCo = availableLogging.singleWhereOrNull((e) => loggingId == e['value']);

    final selectedLocation = getSelectedLocation(location, locations);

    if (contract == null) {
      return const Text('Missing contract');
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DropdownButtonFormField2<Map<String, dynamic>?>(
                value: selectedLoggingCo,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                hint: const Text(
                  'Select a Contract',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                buttonHeight: 60,
                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                items: availableLogging
                    .map(
                      (item) => DropdownMenuItem<Map<String, dynamic>?>(
                        value: item,
                        child: Text(
                          item['label'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please Select a Contract';
                  }
                },
                onChanged: (value) {
                  formStateCallback.call('loggingId', value?['value']);
                  devtools.log('Contract Value: $value');
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: DropdownButtonFormField2<Map<String, dynamic>>(
                value: selectedLocation,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                hint: const Text(
                  'Delivery Location',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                buttonHeight: 60,
                buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                items: [
                  ...getMenuItems(locations),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Please Select a Delivery Location';
                  }
                },
                onChanged: (value) {
                  if (value == null) return;
                  devtools.log('Value: $value');
                  formStateCallback('location', '${value['location']}|${value['id']}');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
