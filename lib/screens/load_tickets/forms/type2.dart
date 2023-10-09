import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/extensions/capitalize_first.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';

// Form Values:

// truckingId
// loggingId
// location
// ticketNumber
// contents
// contractId
class Type2 extends StatelessWidget {
  const Type2({
    required this.contract,
    required this.loggingId,
    required this.truckingId,
    required this.ticketNumber,
    required this.location,
    required this.formStateCallback,
    super.key,
  });

  final Contract? contract;
  final String? loggingId;
  final String? truckingId;
  final String? ticketNumber;
  final String? location;

  final Function(String, String) formStateCallback;

  Future<Map<String, List<Map<String, dynamic>>>> fetchHauling(BuildContext context) async {
    final handle = context.read<HandleProvider>().handle;
    final contractId = contract?.id;

    final enabledLocations = <String, List<Map<String, dynamic>>>{
      'mills': <Map<String, dynamic>>[],
      'landings': <Map<String, dynamic>>[],
    };

    Map<String, List<Map<String, dynamic>>> locations = context.read<SettingsProvider>().locations;
    if (contractId == null) return {};

    final response =
        await FirebaseEnv.firebaseFirestore.collection('$handle/procurement/contracts/$contractId/hauling').get();

    for (final doc in response.docs) {
      final id = doc.id;
      final locationName = id.split('|')[0];
      final locationId = id.split('|')[1];

      final data = doc.data();

      final distance = data['distance'] as String?;
      final config = data['configs'] as Map<String, dynamic>?;

      final hasDistance = distance != null && distance.isNotEmpty;
      final hasConfig = config?.entries.any((e) => e.value.isNotEmpty) ?? false;
      // final flateRate = data['flatrate'] ?? false;

      final isEnabled = (hasConfig || hasDistance);

      if (isEnabled) {
        // find location in settings provider and add to enabled locations
        for (final location in locations[locationName] ?? []) {
          if (location['id'] == locationId) {
            enabledLocations[locationName]?.add(location);
          }
        }
      }
    }

    return enabledLocations;
  }

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

  @override
  Widget build(BuildContext context) {
    final availableLogging = contract?.availableLogging.cast<Map<String, dynamic>>() ?? [];
    final selectedLogging = availableLogging.singleWhereOrNull((e) => loggingId == e['value']);

    final availableTrucking = contract?.availableTrucking.cast<Map<String, dynamic>>() ?? [];
    final selectedTrucking = availableTrucking.singleWhereOrNull((e) => truckingId == e['value']);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DropdownButtonFormField2<Map<String, dynamic>?>(
                value: selectedTrucking,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                ),
                buttonStyleData: ButtonStyleData(
                  height: 60,
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: availableTrucking
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
                    return 'Please Select';
                  }
                },
                onChanged: (value) {
                  if (value == null) return;
                  formStateCallback('truckingId', value['value']);
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: DropdownButtonFormField2<Map<String, dynamic>?>(
                value: selectedLogging,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                ),
                buttonStyleData: ButtonStyleData(
                  height: 60,
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
                    return 'Please Select';
                  }
                },
                onChanged: (value) {
                  formStateCallback.call('loggingId', value?['value']);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            FutureBuilder<Object>(
                future: fetchHauling(context),
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.hasError) {
                    return const CircularProgressIndicator();
                  }

                  final enabledLocations = snapshot.data as Map<String, List<Map<String, dynamic>>>;
                  final locationName = location?.split('|')[0];
                  final locationId = location?.split('|')[1];

                  final selectedLocation =
                      enabledLocations[locationName]?.singleWhereOrNull((e) => e['id'] == locationId);

                  return Expanded(
                    child: DropdownButtonFormField2<Map<String, dynamic>?>(
                      value: selectedLocation,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 60,
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      items: [
                        ...getMenuItems(enabledLocations),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return 'Please Select a Location';
                        }
                      },
                      onChanged: (value) {
                        final locationFormatted = '${value?['location']}|${value?['id']}';
                        formStateCallback.call('location', locationFormatted);
                      },
                    ),
                  );
                }),
            const SizedBox(width: 10.0),
            Expanded(
              child: TextFormField(
                initialValue: ticketNumber ?? '',
                onChanged: (value) {
                  formStateCallback.call('ticketNumber', value);
                },
                decoration: const InputDecoration(
                  isDense: false,
                  isCollapsed: false,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Ticket #',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
