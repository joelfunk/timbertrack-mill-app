import 'package:flutter/material.dart';

import '/enspire_framework/utilities/table_utilities.dart' as table_utilities;
import 'package:timbertrack_mill_app/shared/widgets/search_widget.dart';
import 'package:timbertrack_mill_app/shared/constants.dart' as theme_colors show AppTheme;
import 'package:timbertrack_mill_app/enspire_framework/table_component/builders/table_builders.dart'
    as table_builders;

// Added Assertions to check for correct width on columns
class TableComponent extends StatefulWidget {
  TableComponent({
    super.key,
    required this.data,
    required this.columns,
    required this.callback,
    required this.statusColors,
    this.refresh = false,
    this.expanded = false,
    this.showSearch = false,
    this.shrinkWrap = false,
    this.scrollPhysics,
    this.button,
    this.refreshCallback,
    this.buttonCallback,
    this.searchCallback,
  }) : assert(table_utilities.validateColumns(columns) != false, 'Total widths must equal 100!');

  // Expanded is used for nesting ListView's inside SingleChildScrollView's. If set to false will nest properly.
  // If set to true, will expanded to the remaining length of the screen.
  final bool expanded;
  final bool refresh;
  final bool showSearch;
  final String? button;
  final bool shrinkWrap;
  final List<Color> statusColors;
  final Function()? buttonCallback;
  final Function()? refreshCallback;
  final Function(String val)? searchCallback;
  final ScrollPhysics? scrollPhysics;
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> columns;
  final Function(Map<String, dynamic>? data) callback;

  @override
  State<TableComponent> createState() => _TableComponentState();
}

class _TableComponentState extends State<TableComponent> {
  final TextEditingController _textEditingController = TextEditingController();

  final highlightService = SearchServiceClass();

  final sorter = Sorting();

  ValueNotifier<List<Map<String, dynamic>>> searchResults = ValueNotifier([]);

  late List<Map<String, dynamic>> dataCopy;

  @override
  void initState() {
    super.initState();
    dataCopy = [...widget.data];
  }

  void clearTextCallback() {
    _textEditingController.clear();
    if (widget.searchCallback != null) {
      widget.searchCallback?.call('');
    }
    search('');
  }

  void search(String query) {
    highlightService.highlightWords.value = query.split(' ').where((element) => element.isNotEmpty).toList();

    // Finde Search Results
    final results = <Map<String, dynamic>>[];

    if (query.isNotEmpty) {
      for (final item in widget.data) {
        bool hasMatch = searchItemForMatched(item.entries, query);
        if (hasMatch) results.add(item);
      }
    }
    searchResults.value = results;
  }

  bool searchItemForMatched(Iterable<MapEntry> entries, String query) {
    // if any of the entries matches any word from the query, return true
    for (final entry in entries) {
      if (entry.value.toString().toLowerCase().contains(query.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    highlightService.highlightWords.value.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sorter.orderBy != null) {
      dataCopy.sort(((a, b) => sorter.orderBy == OrderBy.asc
          ? a[sorter.sortBy].compareTo(b[sorter.sortBy])
          : b[sorter.sortBy].compareTo(a[sorter.sortBy])));

      searchResults.value.sort(((a, b) => sorter.orderBy == OrderBy.asc
          ? a[sorter.sortBy].compareTo(b[sorter.sortBy])
          : b[sorter.sortBy].compareTo(a[sorter.sortBy])));
    } else {
      dataCopy = [...widget.data];
    }

    final Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          // Add Button / Button Callback if provided
          if (widget.button != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme_colors.AppTheme.green,
                  ),
                  onPressed: () => widget.buttonCallback?.call(),
                  child: Text(widget.button!),
                ),
                const SizedBox(width: 10)
              ],
            ),

          if (widget.showSearch)
            SearchWidget(
              textEditingController: _textEditingController,
              onChangeCallback: (val) {
                if (widget.searchCallback != null) {
                  widget.searchCallback!.call(val);
                }
                // Use search service if no callback is provider
                // to render search data internally
                search(val);
              },
              clearTextCallback: clearTextCallback,
            ),

          // Table Header
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: theme_colors.AppTheme.tabbarColor,
                ),
              ),
            ),
            child: Row(
              children: [
                for (var column in widget.columns)
                  table_builders.createTableHeaderColumn(
                    column: column,
                    size: size,
                    columns: widget.columns,
                    sorter: sorter,
                    callback: () => setState(
                      () {},
                    ),
                  ),
              ],
            ),
          ),

          // Table Data Rows

          // Expanded is used for nesting ListView's inside SingleChildScrollView's. If set to false will nest properly.
          // If set to true, will expanded to the remaining length of the screen.
          if (widget.expanded)
            widget.searchCallback != null
                ? Expanded(
                    child: widget.refresh
                        ? RefreshIndicator(
                            color: theme_colors.AppTheme.green,
                            onRefresh: () async {
                              widget.refreshCallback?.call();
                            },
                            child: ListView.builder(
                              physics: widget.scrollPhysics,
                              itemCount: widget.data.length,
                              itemBuilder: (context, index) {
                                return table_builders.generateTableDataRow(
                                  statusColors: widget.statusColors,
                                  size: size,
                                  index: index,
                                  lastIndex: widget.data.length - 1,
                                  columns: widget.columns,
                                  dataEntry: widget.data[index],
                                  callback: widget.callback,
                                  highlightService: highlightService,
                                );
                              },
                            ),
                          )
                        : ListView.builder(
                            physics: widget.scrollPhysics,
                            itemCount: widget.data.length,
                            itemBuilder: (context, index) {
                              return table_builders.generateTableDataRow(
                                statusColors: widget.statusColors,
                                size: size,
                                index: index,
                                lastIndex: widget.data.length - 1,
                                columns: widget.columns,
                                dataEntry: widget.data[index],
                                callback: widget.callback,
                                highlightService: highlightService,
                              );
                            },
                          ),
                  )
                : ValueListenableBuilder(
                    valueListenable: searchResults,
                    builder: (context, List<Map<String, dynamic>> value, widget) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: _textEditingController.text.isEmpty ? this.widget.data.length : value.length,
                          itemBuilder: (context, index) {
                            return table_builders.generateTableDataRow(
                              statusColors: this.widget.statusColors,
                              size: size,
                              index: index,
                              lastIndex: this.widget.data.length - 1,
                              columns: this.widget.columns,
                              dataEntry: _textEditingController.text.isEmpty ? dataCopy[index] : value[index],
                              callback: this.widget.callback,
                              highlightService: highlightService,
                            );
                          },
                        ),
                      );
                    },
                  ),

          if (!widget.expanded)
            widget.searchCallback != null
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return table_builders.generateTableDataRow(
                        statusColors: widget.statusColors,
                        size: size,
                        index: index,
                        lastIndex: widget.data.length - 1,
                        columns: widget.columns,
                        dataEntry: widget.data[index],
                        callback: widget.callback,
                        highlightService: highlightService,
                      );
                    },
                  )
                : ValueListenableBuilder(
                    valueListenable: searchResults,
                    builder: (context, List<Map<String, dynamic>> value, widget) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _textEditingController.text.isEmpty ? this.widget.data.length : value.length,
                        itemBuilder: (context, index) {
                          return table_builders.generateTableDataRow(
                            statusColors: this.widget.statusColors,
                            size: size,
                            index: index,
                            lastIndex: this.widget.data.length - 1,
                            columns: this.widget.columns,
                            dataEntry: _textEditingController.text.isEmpty ? this.widget.data[index] : value[index],
                            callback: this.widget.callback,
                            highlightService: highlightService,
                          );
                        },
                      );
                    },
                  )
        ],
      ),
    );
  }
}

class SearchService {
  SearchService._();

  static final SearchService _instance = SearchService._();
  factory SearchService() => _instance;

  ValueNotifier<List<String>> highlightWords = ValueNotifier([]);
}

class SearchServiceClass {
  SearchServiceClass();
  final highlightWords = ValueNotifier(<String>[]);
}

enum OrderBy { asc, desc }

class Sorting {
  String? sortBy;
  OrderBy? orderBy;

  void changeSort(String sortBy, Function() callback) {
    if (this.sortBy != sortBy) {
      this.sortBy = sortBy;
      orderBy = OrderBy.asc;
      callback.call();
    } else if (this.sortBy == sortBy && orderBy == OrderBy.desc) {
      orderBy = null;
      callback.call();
    } else {
      orderBy = orderBy == OrderBy.asc ? OrderBy.desc : OrderBy.asc;
      callback.call();
    }
  }
}
