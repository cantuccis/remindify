import 'package:equatable/equatable.dart';
import 'package:remindify/entities/reminder.dart';

class RemindersState extends Equatable {
  static const initial = RemindersState(errorMessage: "", loading: false);

  final String errorMessage;
  final String successMessage;
  final bool loading;
  final Stream<List<Reminder>>? remindersStream;
  final List<Reminder> currentReminders;
  final DateTime? selectedDate;

  const RemindersState({
    required this.errorMessage,
    required this.loading,
    this.successMessage = '',
    this.currentReminders = const [],
    this.remindersStream,
    this.selectedDate,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        loading,
        successMessage,
        currentReminders,
        remindersStream,
        selectedDate,
      ];

  RemindersState copyWith({
    String? error,
    bool? loading,
    String? successMessage,
    List<Reminder>? currentReminders,
    Stream<List<Reminder>>? remindersStream,
    DateTime? selectedDate,
  }) {
    return RemindersState(
      errorMessage: error ?? this.errorMessage,
      loading: loading ?? this.loading,
      successMessage: successMessage ?? this.successMessage,
      currentReminders: currentReminders ?? this.currentReminders,
      remindersStream: remindersStream ?? this.remindersStream,
      selectedDate: selectedDate ?? this.selectedDate
    );
  }

  RemindersState toLoading() =>
      copyWith(loading: true, error: '', successMessage: '');
  RemindersState toError({required String error}) =>
      copyWith(loading: false, error: error, successMessage: '');
  RemindersState toSuccess({String? successMessage}) =>
      copyWith(loading: false, error: '', successMessage: successMessage);
}
