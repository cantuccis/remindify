import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/features/sign_up/widgets/sing_up_card.dart';
import 'package:remindify/interfaces/services/auth_service.dart';
import 'package:remindify/util/widgets/logo_and_phrase.dart';

import '../../dependency_injector.dart';
import '../../responsive_test_package/screen_size.dart';
import '../../widget_testing_util.dart';

class MockAuthService extends Mock implements AuthService {}

main() {
  final AuthService authService = MockAuthService();
  setUpDependencyInjector(authService: authService);
  setupWidgetTestConfig();

  Widget testWidget = createTesteableWidget(
    SignUpCard(
      signInButton: Row(
        children: [
          SizedBox(
            width: 380,
            child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Go to Sign In',
                )),
          ),
        ],
      ),
    ),
  );

  const String validEmail = "facuarancet97@gmail.com";
  const String validPassword = "somepass";
  final RemindifyUser validRemindifyUser =
      RemindifyUser(id: "somevalidid", email: validEmail);
  group("Sign up card tests", () {
    testWidgets(
      "Sign up card structure",
      (tester) async {
        await tester.pumpWidget(testWidget);
        expect(
          find.ancestor(
            of: find.text("Sign Up"),
            matching: find.byType(ElevatedButton),
          ),
          findsOneWidget,
          reason: "There should be a sign up button",
        );
        expect(
          find.ancestor(
            of: find.text("Go to Sign In"),
            matching: find.byType(TextButton),
          ),
          findsOneWidget,
          reason: "There should be a go to sign in button",
        );
        expect(
          find.ancestor(
            of: find.text("Enter your email"),
            matching: find.byType(TextField),
          ),
          findsOneWidget,
          reason: "There should be an email text field",
        );
        expect(
          find.ancestor(
            of: find.text("Enter your password"),
            matching: find.byType(TextField),
          ),
          findsOneWidget,
          reason: "There should be a password text field ",
        );
        expect(
          find.ancestor(
            of: find.text("Confirm your password"),
            matching: find.byType(TextField),
          ),
          findsOneWidget,
          reason: "There should be a confirm password text field",
        );
        expect(
          find.ancestor(
            of: find.text("Never forget your tasks ever again!"),
            matching: find.byType(LogoAndSlogan),
          ),
          findsOneWidget,
          reason: "There should be a slogan",
        );
      },
    );
    testResponsiveWidgets(
      "Disabled button until password match confirm password",
      breakpoints: ValueVariant<ScreenSize>({iPhone13ProMax}),
      (tester) async {
        await tester.pumpWidget(testWidget);
        expect(
          tester
              .widget<ElevatedButton>(
                find.byKey(const ValueKey("sign-up-card-submit-button")),
              )
              .enabled,
          isFalse,
        );
        final passwordFinder = find.ancestor(
          of: find.text("Enter your password"),
          matching: find.byType(TextField),
        );
        final confirmPasswordFinder = find.ancestor(
          of: find.text("Confirm your password"),
          matching: find.byType(TextField),
        );
        await tester.enterText(passwordFinder, "somepass");
        await tester.enterText(confirmPasswordFinder, "somepassss");
        expect(
          tester
              .widget<ElevatedButton>(
                find.byKey(const ValueKey("sign-up-card-submit-button")),
              )
              .enabled,
          isFalse,
        );
        await tester.enterText(confirmPasswordFinder, "somepass");
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<ElevatedButton>(
                find.byKey(const ValueKey("sign-up-card-submit-button")),
              )
              .enabled,
          isTrue,
        );
      },
    );
  });
}
