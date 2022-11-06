import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/reminders/bloc/reminders_cubit.dart';
import 'package:remindify/features/reminders/bloc/reminders_state.dart';
import 'package:remindify/features/reminders/widgets/reminder_card.dart';

class RemindersList extends StatefulWidget {
  const RemindersList({super.key});

  @override
  State<RemindersList> createState() => _RemindersListState();
}

class _RemindersListState extends State<RemindersList> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = BlocProvider.of<AuthCubit>(context, listen: false)
            .state
            .currentUser
            ?.id ??
        '';
    BlocProvider.of<RemindersCubit>(context, listen: false)
        .loadRemindersStream(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemindersCubit, RemindersState>(builder: (ctx, state) {
      if (state.loading) {
        return const Center(
            child: SizedBox(
                width: 100, height: 100, child: CircularProgressIndicator()));
      }

      return state.currentReminders.isNotEmpty
          ? ListView.builder(
              itemCount: state.currentReminders.length,
              itemBuilder: (lctx, i) {
                return Center(
                  child: SizedBox(
                      width: 500,
                      child: ReminderCard(
                          key: ValueKey(
                              "reminder-${state.currentReminders[i].id}"),
                          reminder: state.currentReminders[i])),
                );
              })
          : const Center(
              child: Text(
              "No reminders",
              style: TextStyle(color: Colors.grey),
            ));
    });
  }
}
