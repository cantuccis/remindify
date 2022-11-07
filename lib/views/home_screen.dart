import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';
import 'package:remindify/features/auth/widgets/auth_enforce.dart';
import 'package:remindify/features/auth/widgets/sing_in_card.dart';
import 'package:remindify/features/reminders/bloc/reminders_cubit.dart';
import 'package:remindify/features/reminders/bloc/reminders_state.dart';
import 'package:remindify/features/reminders/widgets/create_reminder_card.dart';
import 'package:remindify/features/reminders/widgets/header.dart';
import 'package:remindify/features/reminders/widgets/reminders_list.dart';
import 'package:remindify/features/sign_up/widgets/sing_up_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSignIn = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return AuthEnforce(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: 1024,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Header(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: ElevatedButton(
                    child: SizedBox(
                      width: 140,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 3,
                          ),
                          SizedBox(
                            width: 110,
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text("Create reminder")),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              title: const Text("Create reminder"),
                              content: SizedBox(
                                  width: 850,
                                  height: screenHeight > 650
                                      ? 650
                                      : screenHeight * 0.9,
                                  child: ListView(
                                    children: const [
                                      CreateReminder(),
                                    ],
                                  )),
                            );
                          });
                    },
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Expanded(child: RemindersList()),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
