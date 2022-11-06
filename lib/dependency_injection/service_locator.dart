import 'package:get_it/get_it.dart';
import 'package:remindify/firebase/repositories/firebase_reminder_repository.dart';
import 'package:remindify/firebase/repositories/firebase_user_repository.dart';
import 'package:remindify/firebase/services/firebase_auth_service.dart';
import 'package:remindify/interfaces/repositories/reminder_repository.dart';
import 'package:remindify/interfaces/repositories/user_repository.dart';
import 'package:remindify/interfaces/services/auth_service.dart';

class ServiceLocator {
  static final ServiceLocator instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return instance;
  }

  final getIt = GetIt.instance;

  Future<void> initialize() async {
    final userRepository = FirebaseUserRepository();
    final auth = FirebaseAuthService(userRepository: userRepository);
    final reminderRepo = FirebaseReminderRepository();

    getIt
      ..registerSingleton<AuthService>(auth)
      ..registerSingleton<UserRepository>(userRepository)
      ..registerSingleton<ReminderRepository>(reminderRepo);
  }

  ServiceLocator._internal();
}
