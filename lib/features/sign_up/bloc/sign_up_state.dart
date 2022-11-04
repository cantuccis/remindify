import 'package:equatable/equatable.dart';
import 'package:remindify/entities/remindify_user.dart';

class SignUpState extends Equatable {
  static const initial =
      SignUpState(errorMessage: "", loading: false);

  final String errorMessage;
  final String successMessage;
  final bool loading;

  const SignUpState({
    required this.errorMessage,
    required this.loading,
    this.successMessage = '',
  });

  @override
  List<Object?> get props => [
        errorMessage,
        loading,
        successMessage,
      ];

  SignUpState copyWith(
      {String? error,
      bool? loading,
      String? successMessage,}) {
    return SignUpState(
      errorMessage: error ?? this.errorMessage,
      loading: loading ?? this.loading,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  SignUpState toLoading() =>
      copyWith(loading: true, error: '', successMessage: '');
  SignUpState toError({required String error}) =>
      copyWith(loading: false, error: error, successMessage: '');
  SignUpState toSuccess({String? successMessage}) =>
      copyWith(loading: false, error: '', successMessage: successMessage);
}
