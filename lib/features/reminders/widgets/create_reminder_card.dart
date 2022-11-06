import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remindify/entities/reminder.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';
import 'package:remindify/features/reminders/bloc/reminders_cubit.dart';
import 'package:remindify/features/reminders/bloc/reminders_state.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateReminder extends StatefulWidget {
  const CreateReminder({
    super.key,
  });

  @override
  State<CreateReminder> createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminder> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late TimeOfDay _selectedTimeOfDay;

  late final RemindersCubit _remindersCubit;

  @override
  void initState() {
    super.initState();
    _remindersCubit = BlocProvider.of<RemindersCubit>(context);
    _remindersCubit.resetSelectedDate();
    _selectedTimeOfDay = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<RemindersCubit, RemindersState>(
        listener: (ctx, state) {
          Navigator.of(context).pop();
        },
        listenWhen: ((previous, current) =>
            previous.loading &&
            !current.loading &&
            current.errorMessage.isEmpty),
        builder: (ctx, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        enabled: !state.loading,
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          label: Text(
                            'Enter title',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        enabled: !state.loading,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          label: Text(
                            'Enter description',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Flex(
                      mainAxisAlignment: screenWidth > 1000
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      crossAxisAlignment: screenWidth > 1000
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      direction:
                          screenWidth > 1000 ? Axis.horizontal : Axis.vertical,
                      children: [
                        SizedBox(
                            height: 300,
                            width: 400,
                            child: SfDateRangePicker(
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                              onSelectionChanged: (selection) {
                                final newDate = DateTime(
                                    selection.value.year,
                                    selection.value.month,
                                    selection.value.day,
                                    state.selectedDate?.hour ??
                                        DateTime.now().hour,
                                    state.selectedDate?.minute ??
                                        DateTime.now().minute);
                                _remindersCubit.setSelectedDate(newDate);
                              },
                            )),
                        SizedBox(
                          width: 400,
                          height: 400,
                          child: createInlinePicker(
                            context: context,
                            dialogInsetPadding: const EdgeInsets.all(5),
                            onCancel: null,
                            cancelText: "",
                            okText: "",
                            elevation: 0,
                            isOnChangeValueMode: true,
                            value: _selectedTimeOfDay,
                            onChange: (value) {
                              final newDate = DateTime(
                                  state.selectedDate?.year ??
                                      DateTime.now().year,
                                  state.selectedDate?.month ??
                                      DateTime.now().month,
                                  state.selectedDate?.day ?? DateTime.now().day,
                                  value.hour,
                                  value.minute);
                              _remindersCubit.setSelectedDate(newDate);
                            },
                            minuteInterval: MinuteInterval.ONE,
                            is24HrFormat: true,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 252, 93, 79)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: 150,
                            child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: 150,
                            child: !state.loading
                                ? ElevatedButton(
                                    onPressed: _createReminder,
                                    child: const Text("Create"))
                                : const Center(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator()),
                                  ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void _createReminder() {
    final currentUserId = BlocProvider.of<AuthCubit>(context, listen: false)
        .state
        .currentUser
        ?.id;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unexpected error: user not found")));
      return;
    }
    final newReminder = Reminder(userId: currentUserId)
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim();

    _remindersCubit.addReminder(newReminder);
  }
}
