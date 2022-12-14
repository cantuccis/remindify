import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:remindify/features/auth/widgets/sing_in_card.dart';
import 'package:remindify/features/sign_up/widgets/sing_up_card.dart';
import 'package:remindify/interfaces/services/notifications_service.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "auth";

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showSignIn = true;

  @override
  void initState() {
    super.initState();
    GetIt.instance
        .get<NotificationsService>()
        .requestPermissions(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kIsWeb
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).cardColor,
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight > 700 ? screenHeight * 0.1 : 30,
              ),
              SizedBox(
                width: screenWidth > 1000 ? 500 : screenWidth * 0.9,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  reverseDuration: const Duration(milliseconds: 400),
                  child: _showSignIn
                      ? SignInCard(
                          key: const Key("sign-in"),
                          signUpButton: SizedBox(
                            width: 200,
                            child: TextButton(
                                key: const ValueKey("or-sign-up-button"),
                                onPressed: () {
                                  setState(() => _showSignIn = false);
                                },
                                child: const Text(
                                  'Or Sign Up',
                                )),
                          ),
                        )
                      : SignUpCard(
                          key: const Key("sign-up"),
                          signInButton: SizedBox(
                            width: 200,
                            child: TextButton(
                                onPressed: () {
                                  setState(() => _showSignIn = true);
                                },
                                child: const Text(
                                  'Go to Sign In',
                                )),
                          ),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
