import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/util/usecase_result.dart';

abstract class AuthService {
  Future<Result<RemindifyUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
    required Function() onSignedOut,
  });

  Future<Result> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Result> singOut();
}
