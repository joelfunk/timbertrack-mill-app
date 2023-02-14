import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:simple_forms/models/app_form_state.dart';
import 'package:timbertrack_mill_app/config/firebase_env.dart';
import 'package:timbertrack_mill_app/providers/handle_provider.dart';
import 'package:timbertrack_mill_app/extensions/capitalize_first.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/providers/contracts_provider.dart';

import 'dart:developer' as devtools;

class DropDownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  DropDownMenuItemSeparator({this.text, super.key, super.value})
      : super(
          enabled: false,
          child: Container(),
        );

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Form Values Used for this form

// Type 1:
// [] contents
// [] contractId
// [] logginId
// [] location -

// The form values will have to change dynamically.
// When editing type 1 - use type 1 form values
// When editing type 2 - use type 2 form values

// Values will reset on a new form when the Contract Type is changed.

class TruckTicketsFormState extends AppFormState<String, String?> {
  TruckTicketsFormState()
      : super({
          'contract': '',
          'contents': '',
          'loggin_company': null,
          'delivery_location': null,
          'trucking_company': null,
          'land_owner': null,
          'ticket_number': null,
        });
}

class TruckTicketsForm extends StatefulWidget {
  const TruckTicketsForm({
    this.logTicket,
    super.key,
  });
  final Map<String, dynamic>? logTicket;

  @override
  State<TruckTicketsForm> createState() => _TruckTicketsFormState();
}

class _TruckTicketsFormState extends State<TruckTicketsForm> {
  Contract? contract;
  Map<String, dynamic>? contents;
  List<dynamic>? availableLogging;
  Map<String, dynamic>? selectedLogging;

  final _formKey = GlobalKey<FormState>();
  final _contractTypeNotifier = ValueNotifier<String?>(null);

  late final _isEditing = widget.logTicket != null;

  final _formState = <String, String?>{
    'contractId': null,
    'contents': null,
    'logginId': null,
    'location': null,
  };

  @override
  void initState() {
    super.initState();
    // Fetch contract for this truck ticket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Depending on the contract type, fetch the needed fields to populate here
      if (widget.logTicket?['contractId'] != null) {
        final contract = context.read<ContractProvider>().contracts.singleWhere(
              (contract) => contract.id == widget.logTicket?['contractId'],
            );

        final contents = context
            .read<ContractProvider>()
            .contractTypes
            .singleWhere((type) => (type['name'] as String).toLowerCase() == widget.logTicket?['contents']);

        _contractTypeNotifier.value = contract.type;

        setState(() {
          this.contract = contract;
          this.contents = contents;
        });

        // Selected is the value
      }
    });
  }

  void formStateCallback(String key, String value) {
    devtools.log('formStateCallback Key: $key - Value: $value');
    _formState[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    final contractsList = context.read<ContractProvider>().contracts;
    final contractTypes = context.read<ContractProvider>().contractTypes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Tickets Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (_, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField2<Contract?>(
                          value: contract,
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
                            color: _isEditing ? Colors.grey.withOpacity(.3) : Colors.transparent,
                          ),
                          items: contractsList
                              .map(
                                (item) => DropdownMenuItem<Contract>(
                                  value: item,
                                  child: Text(
                                    item.contractName,
                                    style: const TextStyle(
                                      fontSize: 12,
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
                          onChanged: _isEditing
                              ? null
                              : (value) {
                                  _contractTypeNotifier.value = value?.type;
                                  contract = value;
                                  _formState['contractId'] = value?.id;
                                  devtools.log('_formState = ${_formState.toString()}');
                                },
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: DropdownButtonFormField2<Map<String, dynamic>?>(
                          value: contents,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select Contents',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black,
                            ),
                            color: _isEditing ? Colors.grey.withOpacity(.3) : Colors.transparent,
                          ),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: contractTypes
                              .map(
                                (item) => DropdownMenuItem<Map<String, dynamic>>(
                                  value: item,
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select a Content';
                            }
                          },
                          onChanged: _isEditing
                              ? null
                              : (value) {
                                  _formState['contents'] = value?['name'];
                                  devtools.log('_formState = ${_formState.toString()}');
                                },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder(
                    valueListenable: _contractTypeNotifier,
                    builder: (_, String? type, __) {
                      switch (type) {
                        case '1':
                          {
                            return Type1(
                              contract: contract,
                              loggingId: widget.logTicket?['loggingId'],
                              location: widget.logTicket?['location'],
                              formStateCallback: formStateCallback,
                            );
                          }
                        case '2':
                          {
                            return Type2(
                              contract: contract,
                              loggingId: widget.logTicket?['loggingId'],
                              truckingId: widget.logTicket?['truckingId'],
                              ticketNumber: widget.logTicket?['ticketNumber'],
                              formStateCallback: formStateCallback,
                            );
                          }
                        case '3':
                          {
                            return const Text('Case 3');
                          }
                        case '4':
                          {
                            return const Text('Case 3');
                          }
                        case '5':
                          {
                            return const Text('Case 3');
                          }
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Type2 extends StatelessWidget {
  const Type2({
    required this.contract,
    required this.loggingId,
    required this.truckingId,
    required this.ticketNumber,
    required this.formStateCallback,
    super.key,
  });

  final Contract? contract;
  final String? loggingId;
  final String? truckingId;
  final String? ticketNumber;

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
      final hasDistance = distance != null && distance.isNotEmpty;

      final config = data['configs'] as Map<String, dynamic>?;
      final hasConfig = config?.entries.any((e) => e.value.isNotEmpty) ?? false;

      if (hasDistance || hasConfig) {
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
                    return 'Please Select a Trucking Co.';
                  }
                },
                onChanged: (value) {
                  if (value == null) return;
                  devtools.log('Value: $value');
                  formStateCallback('location', '${value['location']}|${value['id']}');
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

                  return Expanded(
                    child: DropdownButtonFormField2<Map<String, dynamic>?>(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
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
                        ...getMenuItems(enabledLocations),
                      ],
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
                  );
                }),
            const SizedBox(width: 10.0),
            Expanded(
              child: TextFormField(
                initialValue: ticketNumber ?? '',
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

// Form fields to edit:
// loggingId
// location: mill|3000 - (setting type)|(id)

// Needing: availabelLogging from procurement/contracts/[id] located in the Contract
// Needing: delivery locations from settings/mills and settings/landings

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
