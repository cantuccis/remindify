import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remindify/entities/reminder.dart';
import 'package:remindify/interfaces/services/notifications_service.dart';
import 'package:remindify/util/exception_handler.dart';
import 'package:remindify/util/usecase_result.dart';

class AwesomeNotificationsService extends NotificationsService {
  final String _channelKey = "basic_channel";
  final String _channelName = "Basic Notifications";
  final String _channelDescription = "Reminder notifications";

  void initialize() {
    if (!kIsWeb) {
      AwesomeNotifications()
          .initialize('resource://drawable/res_notification_app_icon', [
        NotificationChannel(
            channelKey: _channelKey,
            channelName: _channelName,
            channelDescription: _channelDescription,
            locked: true,
            defaultColor: Colors.blueGrey,
            importance: NotificationImportance.High,
            channelShowBadge: true)
      ]);
    }
  }

  @override
  Future<Result> cancelNotification({required String id}) async {
    late final Result result;
    try {
      AwesomeNotifications().cancelSchedule(id.hashCode);
      result = Result.ok();
    } catch (e, stacktrace) {
      handleException(e, stacktrace);
      result = Result.error();
    }
    return result;
  }

  @override
  void requestPermissions({required BuildContext context}) {
    if (!kIsWeb) {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Allow Notifications"),
                    content: const Text(
                        "Send notification permissions must be enabled for this app"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Don\'t Allow",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          )),
                      TextButton(
                          onPressed: () {
                            AwesomeNotifications()
                                .requestPermissionToSendNotifications()
                                .then((_) => Navigator.of(context).pop());
                          },
                          child: const Text(
                            "Allow",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ],
                  ));
        }
      });
    }
  }

  @override
  Future<Result> scheduleNotification({required Reminder reminder}) async {
    late final Result result;
    try {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: reminder.id.hashCode,
              channelKey: _channelKey,
              title: reminder.title,
              body: reminder.description,
              notificationLayout: NotificationLayout.Default),
          schedule: NotificationCalendar(
            year: reminder.reminderDate!.year,
            month: reminder.reminderDate!.month,
            day: reminder.reminderDate!.day,
            hour: reminder.reminderDate!.hour,
            minute: reminder.reminderDate!.minute,
            second: 0,
            millisecond: 0,
          ));
      result = Result.ok();
    } catch (e, stacktrace) {
      handleException(e, stacktrace);
      result = Result.error();
    }
    return result;
  }
}
