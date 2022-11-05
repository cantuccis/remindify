import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/interfaces/repositories/users_repository.dart';
import 'package:remindify/interfaces/services/auth_service.dart';
import 'package:remindify/util/exception_handler.dart';
import 'package:remindify/util/usecase_result.dart';

class FirebaseAuthService extends AuthService {
  late final FirebaseAuth _firebaseAuth;
  late final UserRepository _userRepository;

  FirebaseAuthService(
      {FirebaseAuth? firebaseAuth, UserRepository? userRepository}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    _userRepository = userRepository ?? GetIt.instance.get<UserRepository>();
  }

  @override
  Future<Result<RemindifyUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool persist = true,
    required Function() onSignedOut,
  }) async {
    late final Result<RemindifyUser> result;
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseAuth
          .setPersistence(persist ? Persistence.SESSION : Persistence.NONE);

      if (authResult.user != null) {
        result = await _userRepository.getUser(userId: authResult.user!.uid);
      } else {
        result = Result.error(message: 'Invalid user credentials');
      }

      _firebaseAuth.userChanges().listen((event) {
        if (event == null) {
          onSignedOut();
        }
      });
    } catch (e, stacktrace) {
      handleException(e, stacktrace);
      if (e is FirebaseAuthException) {
        result = Result.error(message: e.message ?? 'Unknown error');
      } else {
        result = Result.error();
      }
    }
    return result;
  }

  @override
  Future<Result> singOut() async {
    late final Result<void> result;
    try {
      await _firebaseAuth.signOut();
      result = Result.ok();
    } catch (e, stacktrace) {
      handleException(e, stacktrace);
      if (e is FirebaseAuthException) {
        result = Result.error(message: e.message ?? 'Unknown error');
      } else {
        result = Result.error();
      }
    }
    return result;
  }

  @override
  Future<Result> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final existsResult = await _userRepository.exists(email: email);
      if (existsResult.isError) return existsResult;

      final exists = (existsResult as ResultSuccess<bool>).data;
      if (exists) return Result.error(message: "User already exists");

      UserCredential authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user == null) {
        return Result.error(message: "User could not be created");
      }
      final user = RemindifyUser(id: authResult.user!.uid, email: email);
      final result = await _userRepository.putUser(user: user);

      return result;
    } catch (e, stacktrace) {
      handleException(e, stacktrace, info: "email: $email");
      return Result.error();
    }
  }

  @override
  Future<Result<RemindifyUser?>> restoreSession() async {
    late final Result<RemindifyUser?> result;
    final firebaseUser = await FirebaseAuth.instance.userChanges().first;
    if (firebaseUser != null) {
        result = await _userRepository.getUser(userId: firebaseUser.uid);
    } else {
        result = Result.success(data: null);
    }
    return result;
  }
}
