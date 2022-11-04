import 'package:flutter/material.dart';
import 'package:remindify/features/auth/widgets/auth_enforce.dart';
import 'package:remindify/features/auth/widgets/sing_in_card.dart';
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return AuthEnforce(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hello world!"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
