import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_text_highlighting/dynamic_text_highlighting.dart';

import 'package:timbertrack_mill_app/enspire_framework/table_component/table_component.dart';
import 'package:timbertrack_mill_app/enspire_framework/utilities/table_utilities.dart' as table_utilities
    show convertWidthToPercent;
import 'package:timbertrack_mill_app/enspire_framework/utilities/timestamp_formatter.dart' as timestamp_formatter
    show timestampToDateString;

Widget checkAndReturnFormattedTypes({
  required String columnType,
  required Size size,
  required int columnWidth,
  required dynamic columnText,
  required bool isExpanded,
  required SearchServiceClass highlightService,
  String? columnFormat,
}) {
  switch (columnType) {
    case 'timestamp':
      {
        return createTimestampTextWidget(
            isExpanded: isExpanded,
            size: size,
            columnWidth: columnWidth,
            columnText: columnText,
            columnFormat: columnFormat,
            highlightService: highlightService);
      }
    case 'datetime':
      {
        return createDateTimeTextWidget(
            size: size,
            columnWidth: columnWidth,
            columnText: columnText,
            isExpanded: isExpanded,
            highlightService: highlightService);
      }
    case 'number':
      {
        return createNumberColumn(
            size: size,
            columnWidth: columnWidth,
            columnText: columnText,
            columnFormat: columnFormat,
            isExpanded: isExpanded,
            highlightService: highlightService);
      }
    case 'icon':
      {
        return createIconColumn(size, columnWidth, columnText, isExpanded);
      }
    default:
      {
        return const SizedBox.shrink();
      }
  }
}

Widget createIconColumn(Size size, int columnWidth, dynamic columnText, bool isExpanded) {
  switch (isExpanded) {
    case true:
      {
        return Expanded(
          child: Container(padding: const EdgeInsets.all(10), child: columnText),
        );
      }
    default:
      {
        return Container(
            width: size.width * table_utilities.convertWidthToPercent(columnWidth),
            padding: const EdgeInsets.all(10),
            child: columnText);
      }
  }
}

Widget createNumberColumn(
    {required int columnWidth,
    required dynamic columnText,
    required Size size,
    required bool isExpanded,
    required SearchServiceClass highlightService,
    String? columnFormat}) {
  switch (columnFormat) {
    case 'usd':
      {
        if (isExpanded) {
          return createExpandedTextColumn(text: '\$$columnText', highlightService: highlightService);
        }
        return createTextColumn(
          text: '\$$columnText',
          width: size.width * table_utilities.convertWidthToPercent(columnWidth),
          highlightService: highlightService,
        );
      }
    default:
      {
        return const SizedBox.shrink();
      }
  }
}

Widget createTimestampTextWidget(
    {required Size size,
    required int columnWidth,
    required dynamic columnText,
    required bool isExpanded,
    required SearchServiceClass highlightService,
    String? columnFormat}) {
  if (isExpanded == true) {
    return createExpandedTextColumn(
      text: timestamp_formatter.timestampToDateString(timestamp: columnText, format: columnFormat),
      highlightService: highlightService,
    );
  }

  return createTextColumn(
    text: timestamp_formatter.timestampToDateString(timestamp: columnText, format: columnFormat),
    width: size.width * table_utilities.convertWidthToPercent(columnWidth),
    highlightService: highlightService,
  );
}

Widget createDateTimeTextWidget({
  required Size size,
  required int columnWidth,
  required dynamic columnText,
  required bool isExpanded,
  required SearchServiceClass highlightService,
  String? columnFormat,
}) {
  final date = DateTime.fromMillisecondsSinceEpoch(columnText * 1000);
  final formattedDate = DateFormat.yMMMd().format(date);

  if (isExpanded == true) {
    return createExpandedTextColumn(text: formattedDate, highlight: false, highlightService: highlightService);
  }

  return createTextColumn(
      text: formattedDate,
      width: size.width * table_utilities.convertWidthToPercent(columnWidth),
      highlight: false,
      highlightService: highlightService);
}

Widget createAndFormatTextColumn(
    {required String text,
    required double? width,
    required bool isExpanded,
    required SearchServiceClass highlightService}) {
  switch (isExpanded) {
    case true:
      {
        return createExpandedTextColumn(text: text, highlightService: highlightService);
      }
    case false:
      {
        return createTextColumn(text: text, width: width, highlightService: highlightService);
      }
    default:
      {
        return createTextColumn(text: text, width: width, highlightService: highlightService);
      }
  }
}

Container createTextColumn({
  required String text,
  required double? width,
  required SearchServiceClass highlightService,
  bool highlight = true,
}) {
  final queryWords = highlightService.highlightWords.value;

  if (!highlight) {
    return Container(
        width: width,
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12.0,
          ),
        ));
  }

  return Container(
    width: width,
    padding: const EdgeInsets.all(10),
    child: ValueListenableBuilder(
      valueListenable: SearchService().highlightWords,
      builder: (context, value, child) {
        return DynamicTextHighlighting(
          key: const Key('highlights-not-expanded'),
          text: text,
          highlights: queryWords,
          caseSensitive: false,
          style: const TextStyle(
            fontSize: 12.0,
          ),
        );
      },
    ),
  );
}

Expanded createExpandedTextColumn({
  required String text,
  required SearchServiceClass highlightService,
  bool highlight = true,
}) {
  final queryWords = highlightService.highlightWords.value;

  if (!highlight) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          )),
    );
  }

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(10),
      child: ValueListenableBuilder(
        valueListenable: SearchService().highlightWords,
        builder: (context, value, child) {
          return DynamicTextHighlighting(
            text: text,
            highlights: queryWords,
            caseSensitive: false,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          );
        },
      ),
    ),
  );
}
