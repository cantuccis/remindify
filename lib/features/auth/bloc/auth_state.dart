import 'package:equatable/equatable.dart';
import 'package:remindify/entities/remindify_user.dart';

class AuthState extends Equatable {
  static const initial = AuthState(errorMessage: "", loading: false);

  final RemindifyUser? currentUser;
  final String errorMessage;
  final String successMessage;
  final bool loading;

  bool get isSignedIn => currentUser != null;

  const AuthState({
    required this.errorMessage,
    required this.loading,
    this.currentUser,
    this.successMessage = '',
  });

  @override
  List<Object?> get props => [
        errorMessage,
        loading,
        currentUser,
        successMessage,
      ];

  AuthState copyWith(
      {bool? isSignedIn,
      String? error,
      bool? loading,
      String? successMessage,
      RemindifyUser? userSignedIn}) {
    return AuthState(
      errorMessage: error ?? this.errorMessage,
      loading: loading ?? this.loading,
      currentUser: userSignedIn ?? this.currentUser,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  AuthState toLoading() =>
      copyWith(loading: true, error: '', successMessage: '');
  AuthState toError({required String error}) =>
      copyWith(loading: false, error: error, successMessage: '');
  AuthState toSuccess({String? successMessage}) =>
      copyWith(loading: false, error: '', successMessage: successMessage);
}
