// import 'package:collection/collection.dart' show IterableExtension;
// import 'package:flutter/material.dart';
// import 'package:mobiletrack_dispatch_flutter/constants/constants.dart' as theme_colors;
// import 'package:mobiletrack_dispatch_flutter/widgets/widgets.dart';

// import '/enspire_framework-port/table_component/builders/table_builders.dart' as table_builders;
// import '/enspire_framework-port/utilities/table_utilities.dart' as table_utilities;

// // Added Assertions to check for correct width on columns
// class TableComponent extends StatefulWidget {
//   TableComponent({
//     super.key,
//     required this.data,
//     required this.columns,
//     required this.callback,
//     required this.statusColors,
//     this.refresh = false,
//     this.expanded = false,
//     this.showSearch = false,
//     this.shrinkWrap = false,
//     this.scrollPhysics,
//     this.button,
//     this.refreshCallback,
//     this.buttonCallback,
//     this.searchCallback,
//     this.groupBy,
//   }) : assert(table_utilities.validateColumns(columns) != false, 'Total widths must equal 100!');

//   // Expanded is used for nesting ListView's inside SingleChildScrollView's. If set to false will nest properly.
//   // If set to true, will expanded to the remaining length of the screen.
//   final bool expanded;
//   final bool refresh;
//   final bool showSearch;
//   final String? button;
//   final bool shrinkWrap;
//   final List<Color> statusColors;
//   final Function()? buttonCallback;
//   final Function()? refreshCallback;
//   final Function(String val)? searchCallback;
//   final ScrollPhysics? scrollPhysics;
//   final Map<String, Object>? groupBy;
//   final List<Map<String, dynamic>> data;
//   final List<Map<String, dynamic>> columns;
//   final Function(Map<String, dynamic>? data) callback;

//   @override
//   State<TableComponent> createState() => _TableComponentState();
// }

// class _TableComponentState extends State<TableComponent> {
//   final TextEditingController _textEditingController = TextEditingController();

//   final highlightService = SearchServiceClass();

//   final sorter = Sorting();

//   ValueNotifier<List<Map<String, dynamic>>> searchResults = ValueNotifier([]);

//   late List<Map<String, dynamic>> dataCopy;

//   Map<String, List<Map<String, dynamic>>>? groupData;

//   @override
//   void initState() {
//     super.initState();
//     dataCopy = [...widget.data];

//     if (widget.groupBy != null) {
//       groupData = gatherGroupByData();
//     }
//   }

//   void clearTextCallback() {
//     _textEditingController.clear();
//     if (widget.searchCallback != null) {
//       widget.searchCallback?.call('');
//     }
//     search('');
//   }

//   Map<String, List<Map<String, dynamic>>>? gatherGroupByData() {
//     final field = widget.groupBy?['field'] as String?;
//     final options = widget.groupBy?['options'] as Map<String, Map>?;

//     final sortedGroups = options?.entries
//         .sorted((a, b) => (a.value[field ?? 'position'] as int).compareTo(b.value[field ?? 'position'] as int));

//     final groupByData = {
//       for (final group in sortedGroups ?? [])
//         group.value['name'] as String: [
//           for (final item in widget.data)
//             if (item['serviceItemTypeId'] == group.value['id']) item,
//         ],
//     };

//     // Remove any groups that are empty
//     groupByData.removeWhere((key, value) => value.isEmpty);

//     return groupByData;
//   }

//   void search(String query) {
//     highlightService.highlightWords.value = query.split(' ').where((element) => element.isNotEmpty).toList();

//     // Finde Search Results
//     final results = <Map<String, dynamic>>[];

//     if (query.isNotEmpty) {
//       for (final item in widget.data) {
//         bool hasMatch = searchItemForMatched(item.entries, query);
//         if (hasMatch) results.add(item);
//       }
//     }
//     searchResults.value = results;
//   }

//   bool searchItemForMatched(Iterable<MapEntry> entries, String query) {
//     // if any of the entries matches any word from the query, return true
//     for (final entry in entries) {
//       if (entry.value.toString().toLowerCase().contains(query.toLowerCase())) {
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   void dispose() {
//     highlightService.highlightWords.value.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (sorter.orderBy != null) {
//       dataCopy.sort(((a, b) => sorter.orderBy == OrderBy.asc
//           ? a[sorter.sortBy].compareTo(b[sorter.sortBy])
//           : b[sorter.sortBy].compareTo(a[sorter.sortBy])));

//       searchResults.value.sort(((a, b) => sorter.orderBy == OrderBy.asc
//           ? a[sorter.sortBy].compareTo(b[sorter.sortBy])
//           : b[sorter.sortBy].compareTo(a[sorter.sortBy])));
//     } else {
//       dataCopy = [...widget.data];
//     }

//     final Size size = MediaQuery.sizeOf(context);

//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: <Widget>[
//           // Add Button / Button Callback if provided
//           if (widget.button != null)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: theme_colors.AppTheme.green,
//                   ),
//                   onPressed: () => widget.buttonCallback?.call(),
//                   child: Text(widget.button!),
//                 ),
//                 const SizedBox(width: 10)
//               ],
//             ),

//           if (widget.showSearch)
//             SearchWidget(
//               textEditingController: _textEditingController,
//               onChangeCallback: (val) {
//                 if (widget.searchCallback != null) {
//                   widget.searchCallback!.call(val);
//                 }
//                 // Use search service if no callback is provider
//                 // to render search data internally
//                 search(val);
//               },
//               clearTextCallback: clearTextCallback,
//             ),

//           // Table Header
//           Container(
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   width: 1,
//                   color: theme_colors.AppTheme.tabbarColor,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 for (var column in widget.columns)
//                   table_builders.createTableHeaderColumn(
//                     column: column,
//                     size: size,
//                     columns: widget.columns,
//                     sorter: sorter,
//                     callback: () => setState(
//                       () {},
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // Table Data Rows

//           // Expanded is used for nesting ListView's inside SingleChildScrollView's. If set to false will nest properly.
//           // If set to true, will expanded to the remaining length of the screen.
//           if (widget.expanded)
//             widget.searchCallback != null
//                 ? Expanded(
//                     child: widget.refresh
//                         ? RefreshIndicator(
//                             color: theme_colors.AppTheme.green,
//                             onRefresh: () async {
//                               widget.refreshCallback?.call();
//                             },
//                             child: ListView.builder(
//                               physics: widget.scrollPhysics,
//                               itemCount: widget.data.length,
//                               itemBuilder: (context, index) {
//                                 return table_builders.generateTableDataRow(
//                                   statusColors: widget.statusColors,
//                                   size: size,
//                                   index: index,
//                                   lastIndex: widget.data.length - 1,
//                                   columns: widget.columns,
//                                   dataEntry: widget.data[index],
//                                   callback: widget.callback,
//                                   highlightService: highlightService,
//                                 );
//                               },
//                             ),
//                           )
//                         : ListView.builder(
//                             physics: widget.scrollPhysics,
//                             itemCount: widget.data.length,
//                             itemBuilder: (context, index) {
//                               return table_builders.generateTableDataRow(
//                                 statusColors: widget.statusColors,
//                                 size: size,
//                                 index: index,
//                                 lastIndex: widget.data.length - 1,
//                                 columns: widget.columns,
//                                 dataEntry: widget.data[index],
//                                 callback: widget.callback,
//                                 highlightService: highlightService,
//                               );
//                             },
//                           ),
//                   )
//                 : ValueListenableBuilder(
//                     valueListenable: searchResults,
//                     builder: (context, List<Map<String, dynamic>> value, _) {
//                       return Expanded(
//                         child: ListView.builder(
//                           itemCount: _textEditingController.text.isEmpty ? widget.data.length : value.length,
//                           itemBuilder: (context, index) {
//                             return table_builders.generateTableDataRow(
//                               statusColors: widget.statusColors,
//                               size: size,
//                               index: index,
//                               lastIndex: widget.data.length - 1,
//                               columns: widget.columns,
//                               dataEntry: _textEditingController.text.isEmpty ? dataCopy[index] : value[index],
//                               callback: widget.callback,
//                               highlightService: highlightService,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),

//           if (!widget.expanded)
//             widget.searchCallback != null
//                 ? ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: widget.data.length,
//                     itemBuilder: (context, index) {
//                       return table_builders.generateTableDataRow(
//                         statusColors: widget.statusColors,
//                         size: size,
//                         index: index,
//                         lastIndex: widget.data.length - 1,
//                         columns: widget.columns,
//                         dataEntry: widget.data[index],
//                         callback: widget.callback,
//                         highlightService: highlightService,
//                       );
//                     },
//                   )
//                 : ValueListenableBuilder(
//                     valueListenable: searchResults,
//                     builder: (context, List<Map<String, dynamic>> value, _) {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: _textEditingController.text.isEmpty
//                             ? groupData != null
//                                 ? (groupData?.entries.length ?? 0)
//                                 : widget.data.length
//                             : value.length,
//                         itemBuilder: (context, index) {
//                           if (groupData != null) {
//                             final group = groupData?.entries.elementAt(index);
//                             final title = group?.key ?? '';
//                             final rows = group?.value ?? [];

//                             return Column(
//                               children: [
//                                 Theme(
//                                   data: ThemeData().copyWith(
//                                     dividerColor: Colors.transparent,
//                                     visualDensity: VisualDensity.compact,
//                                   ),
//                                   child: ExpansionTile(
//                                     backgroundColor: Colors.grey.shade300,
//                                     collapsedBackgroundColor: Colors.grey.shade300,
//                                     iconColor: Colors.black,
//                                     expandedCrossAxisAlignment: CrossAxisAlignment.start,
//                                     collapsedIconColor: Colors.black,
//                                     title: Text(
//                                       title,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     tilePadding: const EdgeInsets.symmetric(
//                                       vertical: 0,
//                                       horizontal: 10,
//                                     ),
//                                     initiallyExpanded: true,
//                                     children: [
//                                       ...rows.map(
//                                         (e) => table_builders.generateTableDataRow(
//                                           statusColors: widget.statusColors,
//                                           size: size,
//                                           index: 1,
//                                           lastIndex: rows.length - 1,
//                                           columns: widget.columns,
//                                           dataEntry: e,
//                                           callback: widget.callback,
//                                           highlightService: highlightService,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }

//                           return table_builders.generateTableDataRow(
//                             statusColors: widget.statusColors,
//                             size: size,
//                             index: index,
//                             lastIndex: widget.data.length - 1,
//                             columns: widget.columns,
//                             dataEntry: _textEditingController.text.isEmpty ? widget.data[index] : value[index],
//                             callback: widget.callback,
//                             highlightService: highlightService,
//                           );
//                         },
//                       );
//                     },
//                   )
//         ],
//       ),
//     );
//   }
// }

// class SearchService {
//   SearchService._();

//   static final SearchService _instance = SearchService._();
//   factory SearchService() => _instance;

//   ValueNotifier<List<String>> highlightWords = ValueNotifier([]);
// }

// class SearchServiceClass {
//   SearchServiceClass();
//   final highlightWords = ValueNotifier(<String>[]);
// }

// enum OrderBy { asc, desc }

// class Sorting {
//   String? sortBy;
//   OrderBy? orderBy;

//   void changeSort(String sortBy, Function() callback) {
//     if (this.sortBy != sortBy) {
//       this.sortBy = sortBy;
//       orderBy = OrderBy.asc;
//       callback.call();
//     } else if (this.sortBy == sortBy && orderBy == OrderBy.desc) {
//       orderBy = null;
//       callback.call();
//     } else {
//       orderBy = orderBy == OrderBy.asc ? OrderBy.desc : OrderBy.asc;
//       callback.call();
//     }
//   }
// }
