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
    emit(state.toLoading());
    final result = await _authService.signUpWithEmailAndPassword(
        email: email, password: password);
    result.when(
      onSuccess: (_) => emit(state.toSuccess()),
      onError: (e) => emit(state.toError(error: e)),
    );
  }
}
