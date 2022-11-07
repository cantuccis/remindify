import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver.dart';
import 'package:remindify/main.dart' as app;
import 'dart:math';

import '../test/widget_testing_util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app.useEmulators = false;

  group("Sign up test", () {
    testWidgets("Successful sign up", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey("or-sign-up-button")));
      await tester.pumpAndSettle();
      final emailFinder = find.ancestor(
        of: find.text("Enter your email"),
        matching: find.byType(TextField),
      );
      final passwordFinder = find.ancestor(
        of: find.text("Enter your password"),
        matching: find.byType(TextField),
      );
      final confirmPasswordFinder = find.ancestor(
        of: find.text("Confirm your password"),
        matching: find.byType(TextField),
      );
      await tester.enterText(
          emailFinder, "facuarancet97+${Random().nextInt(10000)}@gmail.com");
      await tester.enterText(passwordFinder, "somepass");
      await tester.enterText(confirmPasswordFinder, "somepass");
      await tester.pumpAndSettle();
      final signUpSubmitButton =
          find.byKey(const ValueKey("sign-up-card-submit-button"));
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(signUpSubmitButton);

      final createReminderButtonFinder = find.ancestor(
        of: find.text("Create reminder"),
        matching: find.byType(ElevatedButton),
      );
      await pumpUntilFound(tester, createReminderButtonFinder);
      expect(
        createReminderButtonFinder,
        findsOneWidget,
        reason:
            "User should see the create reminder button if successfully signed up",
      );
    });
  });
}
