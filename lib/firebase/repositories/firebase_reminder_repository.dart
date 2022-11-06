import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindify/entities/reminder.dart';
import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/interfaces/repositories/reminder_repository.dart';
import 'package:remindify/util/exception_handler.dart';
import 'package:remindify/util/usecase_result.dart';

class FirebaseReminderRepository extends ReminderRepository {
  late final FirebaseFirestore _firestore;

  FirebaseReminderRepository({FirebaseFirestore? firestore}) {
    _firestore = firestore ?? FirebaseFirestore.instance;
  }

  @override
  Future<Result> addReminder({required Reminder reminder}) async {
    late final Result result;
    try {
      final ref = await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .doc(reminder.userId)
          .collection(Reminder.COLLECTION_NAME)
          .add(reminder.toJson());
      reminder.id = ref.id;
      result = Result.ok();
    } catch (e, stacktrace) {
      handleException(e, stacktrace,
          info: "addReminder - userid: ${reminder.userId}");
      result = Result.error();
    }
    return result;
  }

  @override
  Future<Result<List<Reminder>>> getReminders({required String userId}) async {
    late final Result<List<Reminder>> result;
    try {
      final query = await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .doc(userId)
          .collection(Reminder.COLLECTION_NAME)
          .get();
      final reminders = query.docs
          .map((doc) => Reminder.fromJson(
                id: doc.id,
                userId: userId,
                data: doc.data(),
              ))
          .toList();
      result = Result.success(data: reminders);
    } catch (e, stacktrace) {
      handleException(e, stacktrace, info: "getReminders - userid: ${userId}");
      result = Result.error();
    }
    return result;
  }

  @override
  Future<Result> removeReminder({
    required String userId,
    required String reminderId,
  }) async {
    late final Result<void> result;
    try {
      await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .doc(userId)
          .collection(Reminder.COLLECTION_NAME)
          .doc(reminderId)
          .delete();
      result = Result.ok();
    } catch (e, stacktrace) {
      handleException(e, stacktrace,
          info: "removeReminder - userId: ${userId}, reminderId: $reminderId");
      result = Result.error();
    }
    return result;
  }

  @override
  Future<Result<Stream<List<Reminder>>>> getRemindersStream({
    required String userId,
  }) async {
    late final Result<Stream<List<Reminder>>> result;
    try {
      final queryStream = await _firestore
          .collection(RemindifyUser.COLLECTION_NAME)
          .doc(userId)
          .collection(Reminder.COLLECTION_NAME)
          .snapshots();
      final remindersStream = queryStream
          .map((reminderDocs) => _buildReminders(userId, reminderDocs.docs));
      result = Result.success(data: remindersStream);
    } catch (e, stacktrace) {
      handleException(e, stacktrace, info: "getReminders - userid: ${userId}");
      result = Result.error();
    }
    return result;
  }

  List<Reminder> _buildReminders(
    String userid,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) =>
      docs
          .map((doc) => Reminder.fromJson(
                userId: userid,
                id: doc.id,
                data: doc.data(),
              ))
          .toList();
}
