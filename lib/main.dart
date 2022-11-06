import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:remindify/dependency_injection/service_locator.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/reminders/bloc/reminders_cubit.dart';
import 'package:remindify/features/sign_up/bloc/sign_up_cubit.dart';
import 'package:remindify/firebase_options.dart';
import 'package:remindify/views/routes.dart';
import 'package:remindify/views/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await ServiceLocator.instance.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Remindify';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (BuildContext context) => AuthCubit(),
          ),
          BlocProvider<SignUpCubit>(
            create: (BuildContext context) => SignUpCubit(),
          ),
          BlocProvider<RemindersCubit>(
            create: (BuildContext context) => RemindersCubit(),
          ),
        ],
        child: MaterialApp(
          title: _title,
          routes: routes,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            dividerColor: Colors.transparent,
            primarySwatch: generateMaterialColor(
                color: const Color.fromARGB(255, 56, 113, 167)),
            fontFamily: GoogleFonts.karla().fontFamily,
            // textTheme: GoogleFonts.karlaTextTheme(
            //   ThemeData(brightness: Brightness.light).textTheme,
            // ),
            // scaffoldBackgroundColor: Colors.black,
            // colorScheme: ColorScheme.light(),
            // appBarTheme: AppBarTheme(
            //   backgroundColor: Colors.black,
            //
          ),
          home: const AuthScreen(),
        ));
  }
}
