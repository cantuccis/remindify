import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (ctx, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              state.currentUser?.email ?? "No email available",
              style: const TextStyle(color: Colors.grey),
            ),
          )),
          TextButton(
              onPressed: () => BlocProvider.of<AuthCubit>(context).signOut(),
              child: Row(
                children: const [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Log out")
                ],
              ))
        ]),
      );
    });
  }
}
