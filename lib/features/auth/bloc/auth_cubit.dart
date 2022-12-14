import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:remindify/interfaces/services/auth_service.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final AuthService _authService;

  AuthCubit() : super(AuthState.initial) {
    _authService = GetIt.instance.get<AuthService>();
  }

  Future<void> restoreSession() async {
    emit(state.toLoading());
    final result = await _authService.restoreSession();
    result.when(
        onSuccess: (user) {
          if (user != null) {
            emit(state.toSuccess().copyWith(userSignedIn: user));
          } else {
            emit(state.toSuccess());
          }
        },
        onError: (e) => emit(state.toError(error: e)));
  }

  Future<void> signInSubmit(String email, String password) async {
    emit(state.toLoading());
    if (email.isEmpty) {
      emit(state.toError(error: "Email is empty"));
      return;
    }
    if (password.isEmpty) {
      emit(state.toError(error: "Password is empty"));
      return;
    }
    final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
        onSignedOut: () {
          emit(AuthState.initial);
        });
    result.when(
      onSuccess: (user) {
        emit(state.toSuccess().copyWith(userSignedIn: user));
      },
      onError: (error) {
        emit(state.toError(error: error));
      },
    );
  }

  void resetFields() {
    emit(state.copyWith(error: "", successMessage: ""));
  }

  Future<void> signOut({String errorMessage = ''}) async {
    emit(state.toLoading());
    final result = await _authService.singOut();
    if (result.isError) {
      emit(state.toError(error: result.errorMessage));
    } else {
      emit(AuthState.initial);
    }
  }
}
