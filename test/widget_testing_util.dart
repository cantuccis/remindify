import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remindify/features/sign_up/bloc/sign_up_cubit.dart';

Widget createTesteableWidget(Widget widget) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<SignUpCubit>(
        create: (BuildContext context) => SignUpCubit(),
      ),
    ],
    child: MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        title: "Test",
        home: Builder(builder: (context) {
          return widget;
        }),
      ),
    ),
  );
}

Future<void> setupWidgetTestConfig() async {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
}

Future<void> scroll({
  required WidgetTester tester,
  required double yOffset,
  startGesture = const Offset(0, 300),
}) async {
  final gesture =
      await tester.startGesture(startGesture); //Position of the scrollview
  await gesture.moveBy(Offset(0, yOffset)); //How much to scroll by
  await tester.pumpAndSettle();
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();
    sleep(const Duration(milliseconds: 100));
    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}
