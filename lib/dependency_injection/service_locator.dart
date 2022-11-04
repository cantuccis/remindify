import 'package:get_it/get_it.dart';
import 'package:remindify/firebase/repositories/firebase_user_repository.dart';
import 'package:remindify/firebase/services/firebase_auth_service.dart';
import 'package:remindify/interfaces/repositories/users_repository.dart';
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

    getIt
      ..registerSingleton<AuthService>(auth)
      ..registerSingleton<UserRepository>(userRepository);
  }

  ServiceLocator._internal();
}
