import 'package:get_it/get_it.dart';
import 'package:remindify/interfaces/services/auth_service.dart';

void setUpDependencyInjector({required AuthService authService}) {
  GetIt.instance.registerSingleton<AuthService>(authService);
}
