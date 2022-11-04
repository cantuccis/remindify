class RemindifyUser {
  static const String COLLECTION_NAME = "remindify-users";
  static const String KEY_EMAIL = "email";

  late final String id;
  String? email;

  RemindifyUser({required this.id, this.email});

  RemindifyUser.fromJson(String uid, Map<String, dynamic> data) {
    id = uid;
    email = data[KEY_EMAIL] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      KEY_EMAIL: email,
    };
  }
}
