import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? parseDateTime(dynamic object) {
  if (object is DateTime) {
    return object;
  }
  if (object is String) {
    return DateTime.parse(object);
  }
  if (object is Timestamp) {
    return object.toDate();
  }
  return null;
}
