import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:timbertrack_mill_app/providers/contracts_provider.dart';
import 'package:timbertrack_mill_app/screens/truck_tickets/forms/type1.dart';
import 'package:timbertrack_mill_app/screens/truck_tickets/forms/type2.dart';

import 'dart:developer' as devtools;

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
            .contractTypes
            .singleWhere((type) => (type['name'] as String).toLowerCase() == widget.logTicket?['contents']);

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
