import 'package:flutter/material.dart';

import 'package:timbertrack_mill_app/shared/constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    required this.textEditingController,
    required this.onChangeCallback,
    required this.clearTextCallback,
    this.padding,
    super.key,
  });

  final TextEditingController textEditingController;
  final Function() clearTextCallback;
  final Function(String val) onChangeCallback;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: TextFormField(
        key: const Key('customer-search-text-field'),
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(child: const Icon(Icons.search, color: Colors.black87)),
          suffixIcon: GestureDetector(
            child: const Icon(Icons.clear, color: Colors.black87),
            onTap: () {
              clearTextCallback.call();
            },
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: 'Search',
          labelStyle: const TextStyle(),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.red,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.red,
              width: 2.0,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.green,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.green,
              width: 2.0,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        obscureText: false,
        onChanged: (val) => onChangeCallback.call(val),
        validator: (String? val) => null,
      ),
    );
  }
}
