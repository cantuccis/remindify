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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!BlocProvider.of<AuthCubit>(context, listen: false)
          .state
          .isSignedIn) {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, state) {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      },
      listenWhen: (previous, current) =>
          previous.isSignedIn && !current.isSignedIn,
      child: widget.child,
    );
  }
}
