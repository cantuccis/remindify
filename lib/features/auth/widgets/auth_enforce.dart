import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';
import 'package:remindify/views/auth_screen.dart';

class AuthEnforce extends StatefulWidget {
  const AuthEnforce({super.key, required this.child});

  final Widget child;

  @override
  State<AuthEnforce> createState() => _AuthEnforceState();
}

class _AuthEnforceState extends State<AuthEnforce> {
  @override
  void initState() {
    super.initState();
    if (!BlocProvider.of<AuthCubit>(context).state.isSignedIn) {
      Future(() {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, state) {
        if (!state.isSignedIn) {
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
        }
      },
      child: widget.child,
    );
  }
}
