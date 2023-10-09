import 'package:flutter/material.dart';

import 'package:mobiletrack_dispatch_flutter/constants/constants.dart' as theme_colors;
import 'package:mobiletrack_dispatch_flutter/enspire_framework/table_component/table_component.dart';

import 'package:mobiletrack_dispatch_flutter/enspire_framework/utilities/table_utilities.dart' as table_utilities;
import 'package:mobiletrack_dispatch_flutter/enspire_framework/table_component/builders/table_widgets.dart'
    as table_widgets;

/// Creates each Table Header's Column
Widget createTableHeaderColumn({
  required List<Map<String, dynamic>> columns,
  required Map<String, dynamic> column,
  required Size size,
  required Sorting sorter,
  required Function() callback,
}) {
  final columnIndex = columns.indexOf(column);

  if (columnIndex == columns.length - 1) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          sorter.changeSort(column['field'], () => callback.call());
        },
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
          child: Row(
            children: [
              Text(
                column['name'],
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (sorter.sortBy == column['field'] && sorter.orderBy != null)
                sorter.orderBy == OrderBy.asc ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    );
  }

  return GestureDetector(
    onTap: () {
      sorter.changeSort(column['field'], () => callback.call());
    },
    child: Container(
      width: size.width * table_utilities.convertWidthToPercent(column['width']),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Row(
        children: [
          Flexible(
            child: Text(
              column['name'],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (sorter.sortBy == column['field'] && sorter.orderBy != null)
            sorter.orderBy == OrderBy.asc ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down)
        ],
      ),
    ),
  );
}

Container generateTableDataRow({
  required Size size,
  required int index,
  required int lastIndex,
  required List<Map<String, dynamic>> columns,
  required Map<String, dynamic> dataEntry,
  required Function(Map<String, dynamic> data) callback,
  required List<Color> statusColors,
  required SearchServiceClass highlightService,
}) {
  return Container(
    width: size.width,
    color: index % 2 == 0 ? theme_colors.AppTheme.backgroundColor : Colors.white,
    child: IntrinsicHeight(
      child: GestureDetector(
        onTap: () => callback.call(dataEntry),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add Color if Data Entry contains the color already
            // TODO: Refactor all data entries to previously contains color
            if (dataEntry['color'] != null)
              Container(
                color: dataEntry['color'],
                width: size.width * .01,
              ),

            if (statusColors.isNotEmpty)
              Container(
                color: statusColors[index],
                width: size.width * .02,
              ),

            if (statusColors.isEmpty)
              Container(
                color: Colors.transparent,
                width: size.width * .02,
              ),

            ...columns.map((column) {
              int index = columns.indexOf(column);

              bool lastIndex = index == columns.length - 1;

              dynamic columnText = dataEntry[column['field']];

              if (column['type'] != null) {
                return table_widgets.checkAndReturnFormattedTypes(
                    columnType: column['type'],
                    columnFormat: column['format'],
                    size: size,
                    columnWidth: column['width'],
                    columnText: columnText,
                    isExpanded: lastIndex,
                    highlightService: highlightService);
              }

              return table_widgets.createAndFormatTextColumn(
                  text: columnText.toString(),
                  width: size.width * table_utilities.convertWidthToPercent(column['width']),
                  isExpanded: lastIndex,
                  highlightService: highlightService);
            }).toList()
          ],
        ),
      ),
    ),
  );
}
