import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/util/usecase_result.dart';

abstract class UserRepository {
  Future<Result<RemindifyUser>> getUser({
    required String userId,
    bool fromCache = false,
  });

  Future<Result<bool>> exists({
    required String email,
  });

  Future<Result> putUser({
    required RemindifyUser user,
  });
}
