import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:simple_forms/models/app_form_state.dart';

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
    required this.logTicket,
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

  final _formState = <String, String?>{
    'logginId': null,
    'location': null,
  };

  @override
  void initState() {
    super.initState();
    // Fetch contract for this truck ticket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.logTicket?['contractId'] != null) {
        final contract = context.read<ContractProvider>().contracts.singleWhere(
              (contract) => contract.id == widget.logTicket?['contractId'],
            );

        final contents = context
            .read<ContractProvider>()
            .contractTypes
            .singleWhere((type) => (type['name'] as String).toLowerCase() == widget.logTicket?['contents']);

        _contractTypeNotifier.value = contract.type;

        final availableLogging = contract.availableLogging.map((e) => e).toList();

        final selectedLogging = availableLogging.singleWhere((e) => widget.logTicket?['loggingId'] == e['value']);

        devtools.log('Selected Logging: $selectedLogging');

        setState(() {
          this.contract = contract;
          this.contents = contents;
          this.availableLogging = availableLogging;
          this.selectedLogging = selectedLogging;
        });

        // Selected is the value
      }
    });
  }

  void formStateCallback(String key, String value) {
    devtools.log('Key: $key');
    devtools.log('Value: $value');
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
                          items: contractsList
                              .map(
                                (item) => DropdownMenuItem<Contract>(
                                  value: item,
                                  child: Text(
                                    item.contractName,
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
                            _contractTypeNotifier.value = value?.type;
                            devtools.log('Contract Value: $value');
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
                              return 'Please Select a Contract';
                            }
                          },
                          onChanged: (value) {
                            devtools.log('Contract Value: $value');
                          },
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _contractTypeNotifier,
                    builder: (_, String? type, widget) {
                      switch (type) {
                        case '1':
                          {
                            return Type1(
                              availableLogging: availableLogging ?? [],
                              selectedLogging: selectedLogging,
                              formStateCallback: formStateCallback,
                            );
                          }
                        case '2':
                          {
                            return const Text('Case 2');
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

class Type1 extends StatelessWidget {
  const Type1({
    required this.availableLogging,
    required this.selectedLogging,
    required this.formStateCallback,
    super.key,
  });

  final List<dynamic> availableLogging;
  final Map<String, dynamic>? selectedLogging;
  final Function(String, String) formStateCallback;
  static final _deliveryLocations = <Map<String, dynamic>>[
    {
      'name': 'Mills',
      'locations': ['First Name', 'Second Name']
    },
    {
      'name': 'Landings',
      'locations': ['First Name2', 'Second Name2']
    },
  ];

  List<DropdownMenuItem<String>> getMenuItems(List<dynamic> items) {
    final widgets = <DropdownMenuItem<String>>[];
    for (final item in items) {
      widgets.add(
        DropdownMenuItem(
          enabled: false,
          value: item['name'],
          child: Text(
            item['name'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      for (final location in item['locations'] as List<String>) {
        widgets.add(
          DropdownMenuItem<String>(
            value: location,
            child: Text(location),
          ),
        );
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
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
              child: DropdownButtonFormField2<String?>(
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
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                items: [
                  ...getMenuItems(_deliveryLocations),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Please Select a Contract';
                  }
                },
                onChanged: (value) {
                  devtools.log('Contract Value: $value');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
