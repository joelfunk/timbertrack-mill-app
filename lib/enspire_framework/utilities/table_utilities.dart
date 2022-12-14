import 'dart:math';

import 'package:flutter/material.dart';

/// Validates column has set widths correctly
bool validateColumns(List<Map<String, dynamic>> columns) {
  List<int> widths = columns.map((item) => item['width']).toList().cast<int>();
  int width = widths.reduce((value, element) => value + element);

  if (width < 100 || width > 100) return false;

  return true;
}

/// Converts integer width to double percent
///
/// -.01 for stripe color
double convertWidthToPercent(int width) {
  return width / pow(10, 2) - .01;
}

/// Retrieves the status color for the given data entry
///
/// Requires the status types you are wanting to reference from the SettingsProvider local or global settings
Color getStatusColor(List<dynamic> statusTypes, Map<String, dynamic> dataEntry) {
  final Map<String, dynamic> status = statusTypes.singleWhere(
    (type) => type['id'] == dataEntry['statusId'],
    orElse: () => <String, dynamic>{},
  );

  final statusColor = status['color'] as String?;

  if (status.isEmpty || statusColor == null) return Colors.transparent;

  return Color(int.parse('0xFF${statusColor.replaceAll('#', '')}'));
}
