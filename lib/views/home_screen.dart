import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';
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
        body: Center(
          child: SizedBox(
            width: 1024,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BlocBuilder<AuthCubit, AuthState>(builder: (ctx, state) {
                        return Row(children: [
                          Text(
                              state.currentUser?.email ?? "No email available"),
                          const Spacer(),
                          TextButton(
                              onPressed: () =>
                                  BlocProvider.of<AuthCubit>(context).signOut(),
                              child: Row(
                                children: const [
                                  Icon(Icons.logout),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Log out")
                                ],
                              ))
                        ]);
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
