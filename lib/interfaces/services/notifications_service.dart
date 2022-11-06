import 'package:flutter/cupertino.dart';
import 'package:remindify/entities/reminder.dart';
import 'package:remindify/util/usecase_result.dart';

abstract class NotificationsService {
  Future<Result> scheduleNotification({required Reminder reminder});
  Future<Result> cancelNotification({required String id});
  void requestPermissions({required BuildContext context});
}
