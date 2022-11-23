import 'dart:async';

import 'package:flutter/material.dart';

typedef DialogOptions<T> = Map<String, T?> Function();

FutureOr<T?> showAlertDialog<T>({
  required BuildContext context,
  required DialogOptions dialogOptions,
  bool? error,
  String? title,
  String? content,
}) {
  final options = dialogOptions();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 14,
            color: error == true ? Colors.red : Colors.black,
          ),
        ),
        content: content != null ? Text(content) : const SizedBox.shrink(),
        actions: options.entries.map((e) {
          return TextButton(
            style: TextButton.styleFrom(
              foregroundColor: error == true ? Colors.red : Colors.black,
            ),
            child: Text(e.key),
            onPressed: () => Navigator.of(context).pop(e.value ?? false),
          );
        }).toList(),
      );
    },
  );
}
