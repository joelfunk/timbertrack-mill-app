import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Formats a Timestamp into a Date String for UI
/// 
/// [format] types:
/// - yMMMd
String timestampToDateString({ String? format, required Timestamp timestamp }) {
  
  // default if no format is passed yMMMd
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  return DateFormat(format ??= 'yMMMd').format(date);
}
