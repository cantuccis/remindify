import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:remindify/entities/reminder.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';
import 'package:remindify/features/reminders/bloc/reminders_cubit.dart';
import 'package:remindify/features/reminders/bloc/reminders_state.dart';
import 'package:remindify/util/assets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key, required this.reminder});
  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Row(
            children: [
              if (reminder.reminderDate?.isBefore(DateTime.now()) ?? false)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    " [old]",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 143, 38, 30)),
                  ),
                ),
              Expanded(
                child: Text(reminder.title ?? "No title",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ],
          ),
          leading: SizedBox(
              height: 40,
              width: 40,
              child: (reminder.reminderDate?.isBefore(DateTime.now()) ?? false)
                  ? SvgPicture.asset(
                      AssetUri.appIconSvg,
                      color: Colors.white,
                      colorBlendMode: BlendMode.saturation,
                    )
                  : SvgPicture.asset(
                      AssetUri.appIconSvg,
                    )),
          subtitle: reminder.reminderDate != null
              ? Text(
                  DateFormat("E, d MMM yyyy HH:mm")
                      .format(reminder.reminderDate!),
                  style: Theme.of(context).textTheme.labelLarge)
              : const Text("No date"),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 143, 38, 30),
            ),
            onPressed: () => {
              BlocProvider.of<RemindersCubit>(context)
                  .removeReminder(reminder.userId, reminder.id!),
            },
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(reminder.description ?? "No description",
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
