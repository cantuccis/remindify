import 'package:flutter/cupertino.dart';
import 'package:remindify/features/auth/widgets/auth_enforce.dart';
import 'package:remindify/views/home_screen.dart';
import 'auth_screen.dart';

final routes = {
  AuthScreen.routeName: (BuildContext context) => const AuthScreen(),
  HomeScreen.routeName: (BuildContext context) => const HomeScreen(),
};
