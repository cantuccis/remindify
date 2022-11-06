import 'package:equatable/equatable.dart';
import 'package:remindify/util/date_parser.dart';

class Reminder implements Equatable {
  static const String COLLECTION_NAME = "reminders";
  static const String KEY_TITLE = "title";
  static const String KEY_DESCRIPTION = "description";
  static const String KEY_REMINDER_DATE = "reminder-date";
  static const String KEY_USER_ID = "user-id";

  String? id;
  late final String userId;
  String? title;
  String? description;
  DateTime? reminderDate;

  Reminder(
      {this.id,
      required this.userId,
      this.title = '',
      this.description = '',
      this.reminderDate});

  Reminder.fromJson({
    required this.userId,
    this.id,
    required Map<String, dynamic> data,
  }) {
    title = data[KEY_TITLE] ?? '';
    description = data[KEY_DESCRIPTION];
    reminderDate = parseDateTime(data[KEY_REMINDER_DATE]);
  }

  Map<String, dynamic> toJson() {
    return {
      KEY_TITLE: title,
      KEY_DESCRIPTION: description,
      KEY_REMINDER_DATE: reminderDate,
      KEY_USER_ID: userId,
    };
  }

  @override
  List<Object?> get props => [id, userId];

  @override
  bool? get stringify => false;
}
