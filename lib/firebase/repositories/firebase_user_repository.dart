import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/interfaces/repositories/user_repository.dart';
import 'package:remindify/util/exception_handler.dart';
import 'package:remindify/util/usecase_result.dart';

class FirebaseUserRepository extends UserRepository {
  late final FirebaseFirestore _firestore;

  FirebaseUserRepository({FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
  }

  @override
  Future<Result> putUser({required RemindifyUser user}) async {
    late final Result result;
    try {
      await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      result = Result.ok();
    } catch (e, stacktrace) {
      handleException(e, stacktrace,
          info: "userid: ${user.id}, email: ${user.email}");
      result = Result.error();
    }
    return result;
  }

  @override
  Future<Result<RemindifyUser>> getUser({
    required String userId,
    bool fromCache = false,
  }) async {
    late final Result<RemindifyUser> result;
    try {
      final snapshot = await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .doc(userId)
          .get(GetOptions(
              source: fromCache ? Source.cache : Source.serverAndCache));
      if (snapshot.data() == null) {
        return Result.error(message: "User not found");
      }
      var user = RemindifyUser.fromJson(userId, snapshot.data()!);
      result = Result.success(data: user);
    } catch (e, stacktrace) {
      handleException(e, stacktrace);
      result = Result.error();
    }
    return result;
  }

  @override
  Future<Result<bool>> exists({required String email}) async {
    late final Result<bool> result;
    try {
      final query = await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .where(RemindifyUser.KEY_EMAIL, isEqualTo: email)
          .get();
      result = Result.success(data: query.docs.isNotEmpty);
    } catch (e, stacktrace) {
      handleException(e, stacktrace, info: "email: $email");
      result = Result.error();
    }
    return result;
  }
}
