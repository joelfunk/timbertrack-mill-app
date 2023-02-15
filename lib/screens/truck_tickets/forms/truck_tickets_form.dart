import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/providers/settings_provider.dart';
import 'package:timbertrack_mill_app/screens/truck_tickets/forms/type1.dart';
import 'package:timbertrack_mill_app/screens/truck_tickets/forms/type2.dart';

import 'dart:developer' as devtools;

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
    'truckingId': null,
    'location': null,
    'ticketNumber': null,
    'landownerId': null,
    'outsideMillId': null,
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
            .contentTypes
            .singleWhere((type) => (type['name'] as String).toLowerCase() == widget.logTicket?['contents']);

        devtools.log('contents: $contents');

        _contractTypeNotifier.value = contract.type;

        setState(() {
          this.contract = contract;
          this.contents = contents;
        });
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
    final contentTypes = context.read<ContractProvider>().contentTypes;

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
                              return 'Please Select';
                            }
                            return null;
                          },
                          onChanged: _isEditing
                              ? null
                              : (value) {
                                  _contractTypeNotifier.value = value?.type;
                                  contract = value;
                                  _formState.updateAll((key, value) => null);
                                  _formState['contractId'] = value?.id;
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
                          items: contentTypes
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
                              return 'Please Select';
                            }
                            return null;
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
                              location: widget.logTicket?['location'],
                              formStateCallback: formStateCallback,
                            );
                          }
                        case '3':
                          return Type3(
                            formStateCallback: formStateCallback,
                            contract: contract,
                            logTicket: widget.logTicket,
                            contents: contents?['name']?.toLowerCase(),
                          );
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

// Form Values:
// truckingId
// loggingId
// landownerId
// location
// ticketNumber
// outsideMillId
class Type3 extends StatelessWidget {
  const Type3({
    required this.formStateCallback,
    required this.contract,
    required this.contents,
    this.logTicket,
    super.key,
  });

  final Map<String, dynamic>? logTicket;
  final String? contents;
  final Contract? contract;
  final Function(String key, String value)? formStateCallback;

  @override
  Widget build(BuildContext context) {
    final truckingId = logTicket?['truckingId'] as String?;
    final loggingId = logTicket?['loggingId'] as String?;
    final landownerId = logTicket?['landownerId'] as String?;
    final location = logTicket?['location'] as String?;
    final ticketNumber = logTicket?['ticketNumber'] as String?;
    final outsideMillId = logTicket?['outsideMillId'] as String?;

    final outsideMillIncluded = contract?.outsideMills.any((e) => e['value'] == outsideMillId) ?? false;
    final outsideMills =
        context.read<SettingsProvider>().outsideMills.singleWhereOrNull((e) => e['id'] == outsideMillId);
    // find if the outsideMills types array contains content
    final outsideMillsHasContentType = (outsideMills['types'] as List<dynamic>).any((e) => e['value'] == contents);
    final showOutsideSale = outsideMillIncluded && outsideMillsHasContentType;

    final availableLogging = contract?.availableLogging.cast<Map<String, dynamic>>() ?? [];
    final selectedLogging = availableLogging.singleWhereOrNull((e) => loggingId == e['value']);

    final availableTrucking = contract?.availableTrucking.cast<Map<String, dynamic>>() ?? [];
    final selectedTrucking = availableTrucking.singleWhereOrNull((e) => truckingId == e['value']);

    final availableLandowners = contract?.availableLandowners.cast<Map<String, dynamic>>() ?? [];
    final selectedLandowner = availableLandowners.singleWhereOrNull((e) => landownerId == e['value']);

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
                  'Select Trucking Co',
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
                  return null;
                },
                onChanged: (value) {
                  formStateCallback?.call('loggingId', value?['value']);
                  devtools.log('Contract Value: $value');
                },
              ),
            ),
            const SizedBox(width: 10.0),
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
                hint: const Text(
                  'Select Logging Co',
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
                  return null;
                },
                onChanged: (value) {
                  if (value == null) return;
                  formStateCallback?.call('truckingId', value['value']);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DropdownButtonFormField2<Map<String, dynamic>?>(
                value: selectedLandowner,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Landowner',
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
                items: availableLandowners
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
                  return null;
                },
                onChanged: (value) {
                  formStateCallback?.call('loggingId', value?['value']);
                  devtools.log('Contract Value: $value');
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: TextFormField(
                initialValue: ticketNumber ?? '',
                onChanged: (value) {
                  formStateCallback?.call('ticketNumber', value);
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
        const SizedBox(height: 20.0),
        if (showOutsideSale)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: DropdownButtonFormField2<Map<String, dynamic>?>(
                  value: selectedLandowner,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  isExpanded: true,
                  hint: const Text(
                    'Select Outside Sale',
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
                  items: availableLandowners
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
                    return null;
                  },
                  onChanged: (value) {
                    formStateCallback?.call('loggingId', value?['value']);
                    devtools.log('Contract Value: $value');
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              const Spacer()
            ],
          ),
      ],
    );
  }
}
