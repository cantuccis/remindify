import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:remindify/interfaces/services/auth_service.dart';

import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  late final AuthService _authService;

  SignUpCubit() : super(SignUpState.initial) {
    _authService = GetIt.instance.get<AuthService>();
  }

  void setInitialState() => emit(SignUpState.initial);

  Future<void> signUpWithEmailAndPasswordSubmit(
      String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(error: "Email and password can't be empty"));
      return;
    }
    if (!_isValidEmail(email)) {
      emit(state.copyWith(
          error: "Invalid email syntax. Please insert a valid email."));
      return;
    }
    emit(state.toLoading());
    final result = await _authService.signUpWithEmailAndPassword(
        email: email, password: password);
    result.when(
      onSuccess: (_) => emit(state.toSuccess()),
      onError: (e) => emit(state.toError(error: e)),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
