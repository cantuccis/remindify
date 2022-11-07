import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:remindify/entities/reminder.dart';
import 'package:remindify/interfaces/repositories/reminder_repository.dart';
import 'package:remindify/interfaces/services/notifications_service.dart';

import 'reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  late final ReminderRepository _reminderRepository;
  late final NotificationsService _notificationsService;

  RemindersCubit() : super(RemindersState.initial) {
    _reminderRepository = GetIt.instance.get<ReminderRepository>();
    _notificationsService = GetIt.instance.get<NotificationsService>();
  }

  void setInitialState() => emit(RemindersState.initial);

  Future<void> loadRemindersStream({required String userId}) async {
    emit(state.toLoading());
    final streamResult =
        await _reminderRepository.getRemindersStream(userId: userId);
    streamResult.when(
      onSuccess: (stream) => _setUpStreamSubscription(stream),
      onError: (e) => emit(state.toError(error: e)),
    );
  }

  Future<void> addReminder(Reminder reminder) async {
    emit(state.toLoading());
    reminder.reminderDate = state.selectedDate;
    if (_validateReminder(reminder)) {
      final result = await _reminderRepository.addReminder(reminder: reminder);
      result.when(
        onSuccess: (_) {
          _notificationsService.scheduleNotification(reminder: reminder);
          emit(
            state.toSuccess(successMessage: "Reminder successfully addded"),
          );
        },
        onError: (e) => emit(state.toError(error: e)),
      );
    }
  }

  Future<void> removeReminder(String userId, String reminderId) async {
    emit(
      state.copyWith(
        currentReminders: state.currentReminders
            .where(
              (r) => r.id == reminderId,
            )
            .toList(),
      ),
    );
    _reminderRepository.removeReminder(userId: userId, reminderId: reminderId);
    _notificationsService.cancelNotification(id: reminderId);
  }

  bool _validateReminder(Reminder reminder) {
    if (reminder.title == null || reminder.title == '') {
      emit(state.toError(error: "Title can't be empty"));
      return false;
    }
    if (reminder.reminderDate == null) {
      emit(state.toError(error: "Please select a reminder date"));
      return false;
    }
    if (reminder.reminderDate!.isBefore(DateTime.now())) {
      emit(state.toError(error: "Reminder should be a future date"));
      return false;
    }
    return true;
  }

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void resetSelectedDate() =>
      emit(state.copyWith(selectedDate: DateTime.now()));

  _setUpStreamSubscription(Stream<List<Reminder>> stream) {
    emit(state.toSuccess().copyWith(remindersStream: stream));

    late final StreamSubscription streamSubscription;
    streamSubscription = stream.listen((newReminders) {
      if (stream != state.remindersStream) {
        streamSubscription.cancel();
      } else {
        newReminders.sort((r1, r2) =>
            r1.reminderDate?.compareTo(r2.reminderDate ?? DateTime.now()) ?? 0);
        emit(state.copyWith(currentReminders: newReminders));
      }
    });
    streamSubscription.onError(
      (e) => emit(state.toError(error: "Reminders failed to load.")),
    );
  }
}
