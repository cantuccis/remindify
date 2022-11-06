import 'package:remindify/entities/reminder.dart';
import 'package:remindify/util/usecase_result.dart';

abstract class ReminderRepository {
  Future<Result<List<Reminder>>> getReminders({
    required String userId,
  });

  Future<Result<Stream<List<Reminder>>>> getRemindersStream({
    required String userId,
  });

  Future<Result> addReminder({
    required Reminder reminder,
  });

  Future<Result> removeReminder({
    required String userId,
    required String reminderId,
  });
}
